class SubscriptionsController < ApplicationController
    layout 'legacy'
    before_action -> { authenticate_role!(["manager", "partner"]) }
    #before_action :unsubscribed_user!, except: :complete

    def index
        set_plan
        get_subscription
        if current_user.manager?
            @discount = current_user.daycare.discount_code
        else
            @discount = nil
        end
    end

    def new
        set_plan
        new_subscription        
    end

    def create
        set_plan
        @subscription = @plan.subscriptions.build(subscription_params)
        set_discount_code
        if @subscription.save_with_payment(@discount_code)
            PlanMailer.send_confirmation(current_user).deliver
            #redirect_to complete_plan_subscription_url(@subscription.plan, @subscription), :notice => "Thank you for subscribing!"
            redirect_to ethic_2_path
        else
            render :new
        end
    end

    def complete
        set_subscription
        validate_user_subscription
    end

    def set_userplan
        # unless params[:plan].nil?
        #     current_user.plan_type = params[:plan]
        #     current_user.save
        # end

        # unless params[:discount].nil?
        #     current_user.daycare.discount_code_id = params[:discount]
        #     current_user.daycare.save

        #     plan_discount_code = DiscountCode.find_by(id: params[:discount])
        #     current_user.discount_code = plan_discount_code
        #     current_user.save            
        # end

        if current_user.paid_plan_type > 0
            upgrade_package

            redirect_to dashboard_path            
        else
            redirect_to upgrade_path
        end
    end

    def user_plan
        # if current_user.paid_plan_type >= 2 || (current_user.deposit_required && current_user.plan_type >= 2 )
        # end
        @phase_one_items = Permission.where(daycare_id: 0, partner_id: 0, active: true, member_type: 'manager', sub_type: 2, plan: 2)
        @phase_two_items = Permission.where(daycare_id: 0, partner_id: 0, active: true, sub_type: 2, member_type: 'manager', plan: [2, 3])
        @phase_three_items = Permission.where(daycare_id: 0, partner_id: 0, active: true, sub_type: 2, member_type: 'manager', plan: [2, 3, 4])

        @plan_one = Plan.where(language: I18n.locale.upcase, plan_type: 2).first
        @plan_two = Plan.where(language: I18n.locale.upcase, plan_type: 3).first
        @plan_three = Plan.where(language: I18n.locale.upcase, plan_type: 4).first
        
    end

    private

    def upgrade_package
        if current_user.plan_type == 2
            return
        end      

        @deposit_plan = Plan.where(plan_type: current_user.plan_type, language: I18n.locale.upcase).first
        deposit_amount = @deposit_plan.price
        
        if current_user.plan_type >= 2
          unless current_user.daycare.discount_code_id
              plan_discount_code = DiscountCode.find(current_user.daycare.discount_code_id)
              unless plan_discount_code.nil?
                current_user.daycare.discount_code_id = plan_discount_code.id
                current_user.daycare.save
                current_user.discount_code = plan_discount_code
                current_user.save        
                deposit_amount = deposit_amount * (100-plan_discount_code.value) * 0.01
              end              
          end
        end

        @transaction = Transaction.new
        @transaction.amount   = deposit_amount
        @transaction.currency = @deposit_plan.currency
        @transaction.card_num = current_user.card_number
        @transaction.user_id  = current_user.id

        # Create a charge: this will charge the user's card
        begin
          stripe_customer = current_user.stripe_customer
          if stripe_customer.blank?
            redirect_to upgrade_path
          end

          charge = Stripe::Charge.create(
            :amount => (@transaction.amount * 100).to_i, # Amount in cents
            :currency => @transaction.currency,
            :customer => stripe_customer,
            :description => ""
          )
          
          @transaction.charge_id = charge.id
          @transaction.deposit = true
          @transaction.plan_type = current_user.plan_type
          @transaction.save

          # current_user.deposit_required = false
          current_user.save

        rescue Stripe::CardError => e
          # The card has been declined
        end

        if current_user.plan_type > 1
          send_confirmation_email
        end
    end

    def send_confirmation_email
        @subject = MessageSubject.find_or_create_by(title: ENV['EMAIL_CONFIRMATION_SUBJECT'], language: I18n.locale.downcase) 
        template_key = 'EMAIL_CONFIRMATION_SUBJECT_PLAN'
        @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
        @message_template = @sub_subject.message_templates.find_by(target_role: 0, language: I18n.locale.downcase)

        phase_name = "Phase" + (current_user.plan_type - 1).to_s
        template = @message_template.content.gsub! '[$NAME$]', current_user.name
        template = template.gsub! '[$PHASE_NAME$]', phase_name

        user_plan = Plan.where(plan_type: current_user.plan_type, language: I18n.locale.upcase).first    

        attachment = []
        unless user_plan.document.nil?
          sub_index = user_plan.document.url.index('?')
          unless sub_index.nil?
            attachment << 'http:' + user_plan.document.url.first(sub_index)
          end      
        end
        NotificationMailer.plan_confirmation(current_user, template, attachment).deliver_now
    end


    def subscription_params
        params.require(:subscription).permit(:user_id, :plan_id, :terms, :stripe_card_token, :discount_code).merge(user_id: current_user.id)
    end

    def set_plan
        @plan = Plan.where(plan_type: 1, language: I18n.locale.upcase).first
        @currency = ISO4217::Currency.from_code(@plan.currency.upcase)

        @main_plan = Plan.where(plan_type: current_user.plan_type, language: I18n.locale.upcase).first        
        @main_plan_currency = ISO4217::Currency.from_code(@main_plan.currency.upcase) unless @main_plan.nil?
    end

    def set_subscription
        @subscription ||= Subscription.find(params[:id])
    end

    def new_subscription
        @subscription = Subscription.new
    end

    def get_subscription
        if [0,1].include?(current_user.plan_type)
            @subscription = Subscription.where(transaction_id: nil, user_id: current_user.id).first
            plan_type = (current_user.plan_type == 0) ? 1 : current_user.plan_type
            plan_month = (current_user.plan_type == 0) ? 12 : 1
            if @subscription.nil?
                new_subscription
                @subscription.user_id = current_user.id
                @subscription.plan_id = Plan.where(plan_type: plan_type, language: I18n.locale.upcase).first.id
                @subscription.terms = true
                @subscription.month = plan_month
                @subscription.save
            end
        else
            new_subscription
        end
        @transaction = Transaction.new
    end

    def set_plans
        @plans ||= Plan.all
    end

    def set_range_data
       @range ||= {
            min: @plans.first.allocation,
            max: @plans.last.allocation,
            step: @plans.last.allocation/@plans.count
        }
    end

    def unsubscribed_user!
        unless current_user && current_user.unsubscribed?
            redirect_to dashboard_url, alert: "You already have a subscription associated with your account"
        end
    end

    def validate_user_subscription
        unless current_user.subscription == @subscription
            redirect_to dashboard_url, alert: 'You do not have access to this resource'
        end
    end

    def set_discount_code
        @discount_code = DiscountCode.active.find_by_code(params[:discount_code])
    end
end