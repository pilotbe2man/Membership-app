class PagesController < ApplicationController
    before_action :authenticate_user!, only: [:welcome, :infection]
    #before_action :authenticate_subscribed!, only: :instruction
    before_filter :check_xhr, only: [:mission, :standard, :path]
    layout 'register', :only => [:ethic_5]

    def welcome
    end

    def description
        @user = MeetingUser.new
    end

    def instruction
        @user = MeetingUser.new
    end

    def infection
        set_subjects
    end

    def getting_started
        render layout: 'registration'
    end

    def select_user_type
        render layout: 'registration'
    end

    def implementation

    end

    def invite_registration
      render layout: 'login'
    end

    def home
        @member_type = 'contact'
        @subject = MessageSubject.find_or_create_by(title: ENV['SURVEY_TEMPLATE_SUBJECT'], language: I18n.locale.downcase) 
        template_key = 'SURVEY_TEMPLATE_SUBJECT_' + @member_type.upcase
        @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
        @message_template = @sub_subject.message_templates.find_by(target_role: MessageTemplate.target_roles[@member_type.downcase], language: I18n.locale.downcase)    
        @user = MeetingUser.new
    end

    def journey
        journey_model = GlobalSetting.find_by(key: "Journey Page Mode")
        # if journey_model.value == "userplan_mode"
        #     redirect_to pre_user_plan_path
        # end
    end

    def guide_text
        respond_to do |format|
            type = params[:type].split('.')
            result = { :step => I18n.t(params[:type]), :label => I18n.t('guideline.tour_lable') }
            format.json {render :json => result}
        end
    end

    def guide_page
        if params[:page] == 'manager_survey' && (%(result_step2 result_step3).include? params[:step])
            layout_name = 'registration'
        else
            layout_name = 'dashboard_v2'
        end
        render action: "#{params[:page]}/#{params[:step]}", layout: layout_name
        rescue Exception
            redirect_to dashboard_path            
    end

    def ethic_1
        if params[:plan]
            session[:apply_plan] = params[:plan]
        else
            session[:apply_plan] = 0
        end

        if params[:discount]
            session[:apply_discount] = params[:discount]
        else
            session[:apply_discount] = 0
        end
    end

    def ethic_4
        get_schedule_params
        scheduler = AcuityScheduling.new(@schedule_user.value, @schedule_password.value, @schedule_url.value)
        @app_types = scheduler.get_appointment_types

        rescue Exception
            redirect_to dashboard_path
    end

    def ethic_5
        if params[:name].nil? || params[:email].nil?
            redirect_to dashboard_path
        end
        get_schedule_params
        scheduler = AcuityScheduling.new(@schedule_user.value, @schedule_password.value, @schedule_url.value)
        @app_types = scheduler.get_appointment_types

    end

    def get_available_schedule_time
        get_schedule_params
        scheduler = AcuityScheduling.new(@schedule_user.value, @schedule_password.value, @schedule_url.value)
        
        time_list = scheduler.get_available_schedule_time params

        respond_to do |format|
            format.json {render :json => time_list}
        end

        rescue Exception
            respond_to do |format|
                format.json {render :json => []}
            end
    end

    def add_schedule
        get_schedule_params

        scheduler = AcuityScheduling.new(@schedule_user.value, @schedule_password.value, @schedule_url.value)

        request = {
            :appointmentTypeID => params[:appointment_type],
            :datetime => params[:start_date] + ' ' + params[:start_time],
            :firstName => params[:firstName],
            :lastName => params[:lastName],
            :email => params[:email],
            :phone => params[:phone],
            :fields => [
                {id: @schedule_num_children.value, value: params[:num_children]},
                {id: @schedule_num_worker.value, value: params[:num_worker]},
                {id: @schedule_care_type.value, value: params[:care_type]}
            ]
        }
        apps = scheduler.put_appointment request

        # unless apps["message"].nil?
        #     flash[:alert] = apps["message"]
        # else
        #     flash[:notice] = t('pages.ethic.step4.schedule_success')
        # end

        schedule = Schedule.new({ email: params[:email], appointment_type: params[:appointment_type], datetime: params[:start_date] + ' ' + params[:start_time]})
        if schedule.save
            redirect_to webinar_path(schedule.token)
        else
            render text: "Something went wrong"
        end
    end

    def contact_us
        render layout: 'registration'
    end

    def send_message
        RegistrationMailer.contact_us_message(params[:email], params[:subject], params[:content]).deliver_now
        redirect_to root_path 
    end

    def pre_user_plan
        @phase_one_items = Permission.where(daycare_id: 0, partner_id: 0, active: true, member_type: 'manager', sub_type: 2, plan: 2)
        @phase_two_items = Permission.where(daycare_id: 0, partner_id: 0, active: true, sub_type: 2, member_type: 'manager', plan: [2, 3])
        @phase_three_items = Permission.where(daycare_id: 0, partner_id: 0, active: true, sub_type: 2, member_type: 'manager', plan: [2, 3, 4])

        @plan_one = Plan.where(language: I18n.locale.upcase, plan_type: 2).first
        @plan_two = Plan.where(language: I18n.locale.upcase, plan_type: 3).first
        @plan_three = Plan.where(language: I18n.locale.upcase, plan_type: 4).first
    end

    def get_discount_code
        discount_code = DiscountCode.where(code: params[:code])

        respond_to do |format|
            format.json {render :json => discount_code}
        end        
    end

    def take_action
        # redirect_to getting_started_path
        @illnesses = Illness.by_language(I18n.locale.downcase)
    end

    def account_register
        redirect_to new_user_registration_path(role: 'manager', token: params[:token], deposit: true)
    end

    private

    def set_subjects
        @subjects ||= SurveySubject.where(language: I18n.locale.upcase)
    end

    def check_xhr
      if request.xhr?
        render partial: action_name
      end
    end

    def get_schedule_params
        @schedule_user = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_USER")
        @schedule_password = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_PASSWORD")
        @schedule_url = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_URL")

        @schedule_num_children = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_NUM_OF_CHILD_ID")
        @schedule_num_worker = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_NUM_OF_WORKER_ID")
        @schedule_care_type = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_CARD_TYPE_ID")
    end
end
