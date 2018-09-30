class Users::PasswordsController < Devise::PasswordsController
  layout 'registration'
  before_filter :set_email, only: [:create]


  # GET /resource/password/new
   def new
    super
    role = params[:role]

    if role == 'worker' or role == 'parentee'
      unless params[:daycare_id].present?
        set_daycares
        redirect_to password_select_daycare_path(role: role)
      else
        @daycare = Daycare.find_by_id(params[:daycare_id])
        @departments ||= @daycare.departments
      end
    end
   end

  # POST /resource/password
   def create
    super

    raw, enc = Devise.token_generator.generate(resource.class, :reset_password_token)

    resource.reset_password_token   = enc
    resource.reset_password_sent_at = Time.now.utc
    resource.save(validate: false)

    reset_url = Rails.application.routes.url_helpers.edit_user_password_path(reset_password_token: raw)
    reset_url = "#{request.protocol}#{request.host_with_port}#{reset_url}"
    template = t('mailers.mail_reset_password.content', name: resource.name, url: reset_url).html_safe

    RegistrationMailer.reset_password_confirmation(resource, template).deliver_now
   end

  # GET /resource/password/edit?reset_password_token=abcdef
   def edit
     super
   end

  # PUT /resource/password
   def update
     super
   end

  # protected

   def after_resetting_password_path_for(resource)
     super(resource)
     new_user_session_path(role: params[:role])
   end

  # The path used after sending reset password instructions
   def after_sending_reset_password_instructions_path_for(resource_name)
     super(resource_name)
     flash[:alert] = t('pages.password.password_reset')
     new_user_session_path(role: params[:role])
   end

  def select_daycare
    set_query
    set_daycares
    render 'select_daycare'
  end

  def select_department
    set_daycare
    set_departments
  end

  def check_email_exists
     user_params = params[:user]

     if user_params.present?
       user_name = user_params[:name]
       department_id = user_params[:department_id]

        user = User.find_by(name: user_name)
        child = Child.find_by(name: user_name) unless user.present?
        user = User.find(child.parent_id) if child.present?

        if user.present?
          department = Department.find_by_id(department_id)
          daycare = department.daycare

          if user.daycare == daycare
            @result = "email_present" if user.email.present?
            @result = "email_required" unless user.email.present?     
          end      
        end
      end

      @result = "error" unless user_params.present? and user.present?
      
      respond_to do |format|
        format.json { render json: {:result => @result} } 
        format.html
        format.js { render layout: false }
      end
  end   

  private

   def set_daycares
    @daycares ||= params[:query].present? ? Daycare.search(@query, params[:page], 100, 300) : Daycare.all
   end

   def set_query
      @query = "%#{params[:query]}%"
   end

  def set_email
     user_params = params[:user]

    if user_params.present? and params[:new_email].present?
     user_name = user_params[:name]
     department_id = user_params[:department_id]

      user = User.find_by(name: user_name)
      child = Child.find_by(name: user_name) unless user.present?
      user = User.find(child.parent_id) if child.present?

      if user.present?
        department = Department.find_by_id(department_id)
        daycare = department.daycare

        if user.daycare == daycare
          user.update(email: user_params[:email])  unless user.email.present?
          params[:user][:email] = user.email if user.email.present?
        end      
      end
    end
    
    redirect_to new_user_session_path(role: user_params[:role]) unless params[:user][:email].present?
  end

  def set_daycare
    @daycare ||= Daycare.find(params[:daycare_id])
  end

  def set_departments
    @departments ||= @daycare.departments
    render layout: 'registration'
  end
end
