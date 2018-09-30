class Users::RegistrationsController < Devise::RegistrationsController
  layout 'registration'
  before_filter :configure_sign_up_params, only: [:create]

  def new
    build_resource({})
    init_resource_per_role

    set_minimum_password_length
    yield resource if block_given?
    render "register/#{params[:role]}", locals: {deposit: true}
    #render "register/#{params[:role]}"
  rescue ActionView::MissingTemplate
    redirect_to new_user_session_url
  end

  # POST /resource
  def create
    build_resource(sign_up_params.merge(role: params[:role]))
    set_daycares unless ['manager', 'partner'].include?(params[:role])
    resource.save
    session[:deposit] = false
    yield resource if block_given?
    if resource.persisted?
      if resource.role == "parentee" or resource.role == "worker"
        resource.email_activate
      else   
        unless params[:token].blank?
          @meeting_user = MeetingUser.where(token: params[:token]).first
          unless @meeting_user.nil?
            @meeting_user.delete
          else
            send_confirmation_email(resource)
          end
        else
          send_confirmation_email(resource)
        end
      end  


      if resource.active_for_authentication?
        # set_flash_message! :notice, :signed_up
        # sign_up(resource_name, resource)
        #respond_with resource, location: after_sign_up_path_for(resource), notice: 'You have successfully signed up!'
        sign_in :user, resource                
        render "register/success_#{params[:role]}", locals: {deposit: resource.deposit_required}
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      new_user_daycare unless ['manager', 'partner'].include?(params[:role])
      if ['parentee'].include?(params[:role])
        @daycare ||= Daycare.find params[:user][:user_daycare_attributes][:daycare_id]           
        @departments ||= @daycare.departments if ['parentee'].include?(params[:role])          
      end
      clean_up_passwords resource
      set_minimum_password_length
      render "register/#{params[:role]}"
    end
  end

  def daycare
    @daycare = Daycare.new(daycare_sign_up_params)
    @daycare.country = I18n.locale
    assign_daycare_manager_role
    if @daycare.save
      user = @daycare.users.first

      unless params[:token].blank?
        @meeting_user = MeetingUser.where(token: params[:token]).first
        unless @meeting_user.nil?
          @meeting_user.delete
          user.email_confirmed = true
          user.save
        else
          send_confirmation_email(user)
        end
      else
        send_confirmation_email(user)
      end

      send_email_campaign(user) unless user.deposit_required
      sign_up(:user, user)  
      redirect_to dashboard_path
      # render "register/success_#{params[:role]}", locals: {deposit: user.deposit_required}
      #respond_with user, location: after_sign_up_path_for(user), notice: 'You have successfully signed up!'
    else
      clean_up_passwords resource
      set_minimum_password_length
      render "register/#{params[:role]}"
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      sign_in :user, user
      if user.deposit_required
        redirect_to upgrade_url(type: 'deposit')
      else        
        redirect_to dashboard_url
      end      
    else
      redirect_to root_url
    end
  end

  # Action for calling schedule once
  def schedule_meeting
  end

  def affiliate
    @affiliate = Affiliate.new(affiliate_sign_up_params)

    assign_affiliate_partner_role

    if @affiliate.save
      user = @affiliate.users.first
      send_confirmation_email(user)
      sign_up(:user, user)
      respond_with user, location: after_sign_up_path_for(user), notice: 'You have successfully signed up!'
    else
      clean_up_passwords resource
      set_minimum_password_length
      render "register/#{params[:role]}"
    end
  end

  def new_partner

  end

  #GET /resource/edit
  def edit
    yield resource if block_given?
    render "edit_user"
  end

  def edit_user
    yield resource if block_given?
    get_resource_per_role

    case params[:role]
    when 'manager'
      render "register/edit_#{params[:role]}"
    when 'partner'
        render "register/edit_#{params[:role]}"
    when 'parentee'
      @user = User.find(current_user.id)
      render "register/edit_#{params[:role]}"
    when 'worker'
      render "register/edit_#{params[:role]}"      
      # redirect_to dashboard_path
    when 'medical_professional'
    end
  end

  def update_daycare
    get_daycare

    result = false
    case params[:role]
    when 'manager'
      result = @daycare.update(daycare_manager_params)
    when 'partner'
      get_affiliate
      result = @affiliate.update(affiliate_partner_params)
    when 'parentee'
      childrens = params[:user][:children_attributes]
      puts childrens
      childrens.each do |index, item|
        if item[:id]
          child = Child.find(item[:id])
        else
          child = Child.new
        end

        child.birth_date = item[:birth_date]
        child.name = item[:name]
        child.department_id = item[:department_id]
        child.parent_id = current_user.id

        result = child.save
      end
    when 'medical_professional'
    end

    if result
      redirect_to dashboard_path
      #render "register/success_#{params[:role]}"
      #respond_with user, location: after_sign_up_path_for(user), notice: 'You have successfully signed up!'
    else
      render "register/edit_#{params[:role]}"
    end
  end
  
  # PUT /resource
  def update
    @user = User.find(current_user.id)
    
    if @user.update_with_password(user_params_password)
      sign_in @user, :bypass => true
      get_resource_per_role      

      case params[:role]
      when 'manager'
        render "register/edit_#{params[:role]}"
      when 'partner'
        render "register/edit_#{params[:role]}"
      when 'parentee'
        render "register/edit_#{params[:role]}"
      when 'worker'
        redirect_to dashboard_path
      when 'medical_professional'
      end
    else
      render "edit_user"
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def init_resource_per_role
    case params[:role]
    when 'manager'
      new_daycare_department
    when 'partner'
      new_affiliate
    when 'parentee'
      set_daycare
      set_departments
      new_child
      new_user_daycare
    when 'worker'
      set_daycares      
      new_user_daycare if params[:option].to_i > 1
      new_user_affiliate if params[:option].to_i < 2
    when 'medical_professional'
      new_user_profile
    end
  end

  def get_resource_per_role
    case params[:role]
    when 'manager'
      get_daycare_department
    when 'partner'
      get_affiliate
    when 'parentee'
      get_daycare
      set_departments
      get_child
    when 'worker'
      set_daycares
      get_daycare_department
    when 'medical_professional'
      new_user_profile
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up).push(
      :name,
      :department_id,
      user_daycare_attributes: [:daycare_id, :user_id],
      user_affiliate_attributes: [:affiliate_id, :user_id],
      children_attributes: [:_destroy, :id, :name, :parent_id, :department_id, :birth_date, profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]],
      user_profile_attributes: [:id, :phone_number, :physical_address, :web_address, :about_yourself, :education, :online_presence, certifications: [], profile_image_attributes: [:id, :attachable_type, :attachable_id, :file], doctor_specialization_attributes: :medical_specialization_id],
      profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]
    )
  end

  def daycare_sign_up_params
    params.require(:daycare).permit(
      :name,
      :address_line1,
      :postcode,
      :municipal_id,
      #:country,
      :telephone,
      :care_type,
      :url,
      :num_children,
      :num_worker,
      :discount_code_id,
      departments_attributes: [:_destroy, :name],
      user_daycares_attributes: [:daycare_id, :user_id, user_attributes: [:name, :email, :password_confirmation, :password, :role, :deposit_required, :plan_type]],
      profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]
    )
  end

  def affiliate_sign_up_params
    params.require(:affiliate).permit(
      :name,
      :address,
      :postcode,
      :municipal_id,
      #:country,
      :telephone,
      #:url,
      :affiliate_type,
      :num_member,
      user_affiliates_attributes: [:affiliate_id, :user_id, user_attributes: [:name, :email, :password_confirmation, :password, :role, :plan_type]]
      #profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]
    )
  end

  def set_daycares
    @daycares ||= Daycare.all
  end

  def get_daycare
    @daycare ||= current_user.daycare
  end

  def new_child
    child = resource.children.build
    child.build_profile_image
  end

  def get_child
    
  end

  def new_daycare_department
    @meeting_user = nil
    unless params[:token].nil?
      @meeting_user = MeetingUser.where(token: params[:token]).first
    end
    @daycare = Daycare.new
    @daycare.build_profile_image
    @daycare.departments.build
    @user_daycare = @daycare.user_daycares.build
    @user_daycare.build_user

    unless @meeting_user.nil?
      @daycare.name = @meeting_user.daycare_name
      @user_daycare.user.email = @meeting_user.email
      @user_daycare.user.name = @meeting_user.name
      @user_daycare.user.email_confirmed = true
      @daycare.telephone = @meeting_user.mobile
    end
  end

  def get_daycare_department
    @daycare = current_user.daycare
  end

  def new_affiliate
    @affiliate = Affiliate.new
    @affiliate.build_profile_image
    @user_affiliate = @affiliate.user_affiliates.build
    @user_affiliate.build_user
  end

  def get_affiliate
    @affiliate = current_user.affiliate
  end

  def new_user_daycare
    resource.build_user_daycare
  end

  def new_user_affiliate
    resource.build_user_affiliate
  end

  def assign_daycare_manager_role
    @daycare.user_daycares.first.user.role = params[:role]
  end

  def assign_affiliate_partner_role
    @affiliate.user_affiliates.first.user.role = params[:role]
  end

  def send_confirmation_email user
    #RegistrationMailer.registration_confirmation(user).deliver_later
    host_name = LocaleUrl.find_by(language: I18n.locale.downcase)
    host_url = (host_name.nil?) ? t("mailers.supermanager.url") : host_name.url
    confirm_url = "http://#{host_url}/confirm_email/#{user.confirm_token}"
    @subject = MessageSubject.find_or_create_by(title: ENV['EMAIL_VERIFICATION_SUBJECT'], language: I18n.locale.downcase) 
    template_key = 'EMAIL_VERIFICATION_SUBJECT_' + ((user.deposit_required) ? "DEPOSIT" : "REGISTER")
    @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
    @message_template = @sub_subject.message_templates.find_by(target_role: 0, language: I18n.locale.downcase)

    template = @message_template.content.gsub! '[$NAME$]', user.name
    template = template.gsub! '[$EMAIL_VERIFICATION_URL$]', confirm_url

    RegistrationMailer.registration_confirmation(user, template).deliver_now
  end

  def send_email_campaign user
    @email_campaigns = EmailCampaign.by_language(I18n.locale.downcase)
    @email_campaigns.each do |item|
      RegistrationMailer.register_email_campaign(user, item.subject, item.content).deliver_now
    end
  end

  def set_daycare
    @daycare ||= Daycare.first
  end

  def set_departments
    @departments ||= @daycare.departments
  end

  def new_user_profile
    profile = resource.build_user_profile
    profile.build_profile_image
    profile.build_doctor_specialization
  end

  def user_params_password
    params.require(:user).permit(:password, :password_confirmation, :current_password, :name, :email)      
  end

  def daycare_manager_params
    params.require(:daycare).permit(:name, :url, :address_line1, :postcode, :country, :telephone, :num_children, :num_worker,
                                    departments_attributes: [:_destroy, :name, :id])      
  end

  def affiliate_partner_params
    params.require(:affiliate).permit(:name, :url, :address, :postcode, :country, :telephone,
                                      profile_image_attributes: [:id, :file])      
  end

  def daycare_parentee_params
    params.require(:user).permit(children_attributes: [:id, :name, :birth_date, :department_id])      
  end
  
  # def build_resource params
  #   self.resource = User.new(params)
  #   resource.build_
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
