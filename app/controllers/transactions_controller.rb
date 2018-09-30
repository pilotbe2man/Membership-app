class TransactionsController < ApplicationController
  def create
    if current_user.plan_type == 2
      if current_user.manager?  
        redirect_to ethic_2_path
      else
        redirect_to dashboard_path
      end
    end      

    @plan = Plan.where(plan_type: 1, language: I18n.locale.upcase).first

    current_plan_type = current_user.plan_type
    @deposit_plan = Plan.where(plan_type: current_plan_type, language: I18n.locale.upcase).first

    # bill_amount = 0;
    # @subscription = nil
    # unless params[:subscription_id].blank?
    #   @subscription = Subscription.find(params[:subscription_id])
    #   days = 0
    #   unless @subscription.payment_mode.nil?
    #     case @subscription.payment_mode.unit
    #     when 'week'
    #       days = 7 * @subscription.payment_mode.period
    #     when 'month'
    #       days = 30 * @subscription.payment_mode.period
    #     when 'year'        
    #       days = 30 * @subscription.payment_mode.period * 12
    #     end
    #   end

    #   full_amount = @plan.price * current_user.daycare.num_children * days
    #   bill_amount = @subscription.discount_code.nil? ? full_amount : full_amount * (100-@subscription.discount_code.value) * 0.01
    #   if current_user.transactions.where(deposit: false).count == 0
    #     bill_amount -= current_user.total_deposit_amount
    #     bill_amount = 0 if bill_amount <= 0
    #   end
    # end

    deposit_amount = @deposit_plan.price
    
    if current_user.plan_type >= 2
      plan_discount_code = current_user.daycare.discount_code
      unless plan_discount_code.nil?
        # current_user.daycare.discount_code_id = plan_discount_code.id
        # current_user.daycare.save
        # current_user.discount_code = plan_discount_code
        # current_user.save        
        deposit_amount = deposit_amount * (100-plan_discount_code.value) * 0.01
      end
    elsif current_user.plan_type == 1
      # deposit_amount = deposit_amount * current_user.affiliate.num_member
      if current_user.manager?  
        deposit_amount = deposit_amount * current_user.daycare.departments.count
      else
        deposit_amount = deposit_amount * current_user.affiliate.num_member
      end
    end

    if deposit_amount == 0
      if current_user.manager?  
        redirect_to ethic_2_path
      else
        redirect_to dashboard_path
      end
    end

    @transaction = Transaction.new
    @transaction.amount   = deposit_amount #params[:upgrade_type] ? deposit_amount : bill_amount
    @transaction.currency = @deposit_plan.currency #params[:upgrade_type] ? @deposit_plan.currency : @plan.currency
    @transaction.card_num = params[:card_number]
    @transaction.user_id  = current_user.id

    user_upgraded = false

    # Create a charge: this will charge the user's card
    begin
      stripe_customer = current_user.stripe_customer
      if stripe_customer.blank?
        stripe_customer = Stripe::Customer.create(
          :email => current_user.email,
          :source => params[:stripe_card_token],
        ).id
      end

      charge = Stripe::Charge.create(
        :amount => (@transaction.amount * 100).to_i, # Amount in cents
        :currency => @transaction.currency,
        :customer => stripe_customer,
        :description => ""
      )
      
      if current_user.deposit_required && !charge.id.nil?
        # current_user.deposit_required = false
        # current_user.plan_type = 4
        user_upgraded = true
      end

      @transaction.charge_id = charge.id
      @transaction.deposit = !current_user.deposit_required  #params[:upgrade_type] ? true : false
      @transaction.plan_type = current_user.plan_type
      @transaction.save

      unless @subscription.nil?
        @subscription.transaction_id = @transaction.id
        @subscription.save        
      end
      
      current_user.stripe_customer = stripe_customer
      current_user.card_number = params[:card_number]
      current_user.save

      if current_user.plan_type > 1 && !user_upgraded
        send_confirmation_email
      end

      if current_user.manager?  
        redirect_to ethic_2_path
      else
        puts "***************** Current User is not manager *********************"
        redirect_to dashboard_path
      end

    rescue Stripe::CardError => e
      puts "**************************************"
      puts e
      redirect_to dashboard_path
      # The card has been declined
    rescue Stripe::InvalidRequestError => e
      puts "**************************************"
      puts e
      redirect_to dashboard_path
    end
  end 

  private

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

end
