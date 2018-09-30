class DashboardController < ApplicationController
    layout :resolve_layout
    before_action :authenticate_subscribed!
    before_action :set_notifications

    def index
      get_permission

      if current_user.partner? && !current_user.affiliate.nil?
        if current_user.affiliate.certific? && current_user.affiliate.users.length > current_user.affiliate.num_member + 1
          upgrade_partner_deposit
        end
      end
      @counter = current_user.notifications.collect{|n| n.source.owner.name}.uniq
      render "dashboard/#{current_user.role}", format: [:html]
      rescue ActionView::MissingTemplate
        redirect_to current_user.admin? ? admin_root_url : root_url
    end

    def approve_notify_department
      @health_record = HealthRecord.find(params[:id])
      render partial: 'dashboard/health_record_department', locals: {record: @health_record}
    end

    def approve_notify_section
      @health_record = HealthRecord.find(params[:id])

      render partial: 'dashboard/health_record_approve', locals: {record: @health_record, department_name: params[:department_text], department_id: params[:department]}
    end

    def approve_notify
      @health_record = HealthRecord.find(params[:id])

      roles = []
      if params[:role].to_i == 1
        roles = ["worker"]
      elsif params[:role].to_i == 0
        roles = ["parentee"]
      else
        roles = ["worker", "parentee"]
      end

      message = Message.new
      message.message_template_id = 0
      message.title = t('mailers.illness.title')
      message.content = t('mailers.illness.content', illness: @health_record.illness_name)
      message.target_roles = roles
      message.owner_id = current_user.id
      message.save

      if message.save
        if params[:department].to_i == 0
          MessageNotificationJob.perform_now(message, {illness: true})
        else
          MessageNotificationJob.perform_now(message, {illness: true, target_department: params[:department]})
        end
      end

      @health_record.alert_status =  1
      @health_record.save

      render partial: 'dashboard/health_record_list'
    end

    def decline_notify
      @health_record = HealthRecord.find(params[:id])
      @health_record.alert_status =  1
      @health_record.save
      # @health_record = HealthRecord.find_by(id: params[:id])
      # unless @health_record.nil?
      #   @health_record.health_record_components.destroy_all
      #   @health_record.destroy
      # end
      render partial: 'dashboard/health_record_list'
    end

    def notify_list_section
      render partial: 'dashboard/health_record_list'
    end

    private

    def set_notifications
      @notifications ||= current_user.notifications.unread
      @notifications_by_sender ||= Notification.count_by_owner(current_user.id)
    end

    def get_permission
      group = 0
      sub_type = 0
      daycare_id = 0
      case current_user.role
      when 'manager'
        group = 0
        sub_type = current_user.daycare.care_type + 1 rescue 1
        daycare_id = current_user.daycare.id rescue 0
      when 'worker'
        group = 1
        if current_user.daycare.nil?
          sub_type = current_user.affiliate.affiliate_type
          daycare_id = current_user.affiliate.id
        else
          sub_type = current_user.daycare.care_type + 1  rescue 1
          daycare_id = current_user.daycare.id
        end
      when 'parentee'
        group = 2
        sub_type = (current_user.daycare.care_type + 1) rescue 1
        daycare_id = current_user.try(:daycare).try(:id)
      when 'partner'
        group = 3
        sub_type = current_user.affiliate.affiliate_type
        daycare_id = current_user.affiliate.id
      end

      unless current_user.daycare.nil?
        @permissions = Permission.where(member_type: group, sub_type: sub_type, daycare_id: daycare_id).order(:order)
        if @permissions.blank?
          @permissions = Permission.where(member_type: group, sub_type: sub_type, daycare_id: 0).order(:order)
        end
      else
        @permissions = Permission.where(member_type: group, sub_type: sub_type, partner_id: daycare_id).order(:order)
        if @permissions.blank?
          @permissions = Permission.where(member_type: group, sub_type: sub_type, partner_id: 0).order(:order)
        end
      end
    end

    def upgrade_partner_deposit
      if current_user.plan_type == 2
        return
      end
        @deposit_plan = Plan.where(plan_type: current_user.plan_type, language: I18n.locale.upcase).first
        deposit_amount = @deposit_plan.price

        deposit_amount = deposit_amount * (current_user.affiliate.users.length - current_user.affiliate.num_member - 1)

        @transaction = Transaction.new
        @transaction.amount   = deposit_amount
        @transaction.currency = @deposit_plan.currency
        @transaction.card_num = current_user.card_number
        @transaction.user_id  = current_user.id

        # Create a charge: this will charge the user's card
        begin
          stripe_customer = current_user.stripe_customer
          if stripe_customer.blank?
            return
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

          current_user.affiliate.num_member = current_user.affiliate.users.length - 1
          current_user.affiliate.save

        rescue Stripe::CardError => e
          # The card has been declined
        end

        if current_user.plan_type > 1
          send_deposit_confirmation_email
        end
    end

    def send_deposit_confirmation_email current_user
        # @subject = MessageSubject.find_or_create_by(title: ENV['EMAIL_CONFIRMATION_SUBJECT'], language: I18n.locale.downcase)
        # template_key = 'EMAIL_CONFIRMATION_SUBJECT_PLAN'
        # @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
        # @message_template = @sub_subject.message_templates.find_by(target_role: 0, language: I18n.locale.downcase)

        # phase_name = "Phase" + (current_user.plan_type - 1).to_s
        # template = @message_template.content.gsub! '[$NAME$]', current_user.name
        # template = template.gsub! '[$PHASE_NAME$]', phase_name

        # user_plan = Plan.where(plan_type: current_user.plan_type, language: I18n.locale.upcase).first

        # attachment = []
        # unless user_plan.document.nil?
        #   sub_index = user_plan.document.url.index('?')
        #   unless sub_index.nil?
        #     attachment << 'http:' + user_plan.document.url.first(sub_index)
        #   end
        # end
        # NotificationMailer.plan_confirmation(current_user, template, attachment).deliver_later
    end

    def resolve_layout
      case current_user.role
      when "manager"
        "sections"
      else
        "sections"
      end
    end
end
