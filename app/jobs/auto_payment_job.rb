class AutoPaymentJob < ActiveJob::Base
    queue_as :default

    def perform *args
        @job_subscriptions = Subscription.all
        @job_subscriptions.each do |subitem|
            unless subitem.transaction_id.nil?
                last_transaction = Transaction.find(subitem.transaction_id)
                user_payment_start = subitem.user.daycare.payment_start

                days = 0
                if last_transaction.deposit == false                
                  unless subitem.payment_mode.nil?
                    if subitem.plan_id == 1
                      case subitem.payment_mode.unit
                      when 'week'
                        days = 7 * subitem.payment_mode.period
                      when 'month'
                        days = 30 * subitem.payment_mode.period
                      when 'year'        
                        days = 30 * subitem.payment_mode.period * 12
                      end
                    else
                      days = 30
                    end
                  end
                else
                  unless user_payment_start.nil?
                    case user_payment_start.unit
                    when 'week'
                      days = 7 * subitem.payment_mode.period
                    when 'day'
                      days = subitem.payment_mode.period
                    end
                  end                  
                end
                unless last_transaction.nil?
                    if DateTime.now.days_ago(days) > last_transaction.created_at
                      pay_subscription subitem
                    end
                end
            end
        end
    end

    private

    def pay_subscription subscription
        @job_subscription = subscription

        @job_plan = Plan.where(plan_type: 1, language: I18n.locale.upcase).first
        @job_user = User.find(subscription.user_id)

        days = 0
        unless @job_subscription.payment_mode
          case @job_subscription.payment_mode.until
          when 'week'
            days = 7 * @job_subscription.payment_mode.period
          when 'month'
            days = 30 * @job_subscription.payment_mode.period
          when 'year'        
            days = 30 * @job_subscription.payment_mode.period * 12
          end
        end

        num_departments = @job_user.daycare.departments.count
        if num_departments == 0 
          return 
        end

        full_amount = @job_plan.price * num_departments * days
        bill_amount = @job_subscription.discount_code.nil? ? full_amount : full_amount * (100-@job_subscription.discount_code.value) * 0.01
        if @job_user.transactions.where(deposit: false).count == 0
          bill_amount -= @job_user.total_deposit_amount
          bill_amount = 0 if bill_amount <= 0
        end

        if [3, 4].include? @job_user.plan_type
          @job_plan = Plan.where(plan_type: @job_user.plan_type, language: I18n.locale.upcase).first
          bill_amount = @job_plan.price
        elsif @job_user.plan_type == 2
          return
        end

        @job_transaction = Transaction.new
        @job_transaction.amount = bill_amount
        @job_transaction.currency = @job_plan.currency
        @job_transaction.card_num = @job_user.card_number
        @job_transaction.user_id = @job_user.id

        # Create a charge: this will charge the user's card
        begin
          charge = Stripe::Charge.create(
            :amount => (@job_transaction.amount * 100).to_i, # Amount in cents
            :currency => @job_transaction.currency,
            :customer => @job_user.stripe_customer,
            :description => ""
          )
          @job_transaction.charge_id = charge.id
          @job_transaction.deposit = false
          @job_transaction.save

          @job_subscription.transaction_id = @job_transaction.id
          @job_subscription.save

        rescue Stripe::CardError => e
          # The card has been declined
        end
    end

end