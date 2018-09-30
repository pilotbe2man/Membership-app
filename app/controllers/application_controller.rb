class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    helper_method :current_daycare
    before_action :set_locale
 
    def set_locale
      local_name = LocaleUrl.find_by(url: request.host)
      if local_name.nil?
        I18n.locale = I18n.default_locale
      else
        I18n.locale = local_name.language
      end       
    end

    def authenticate_role! roles
        if current_user.nil?
            redirect_to new_user_session_url
        elsif current_user && !(roles.include?(current_user.role))
            redirect_to root_url
        end
    end

    def strategic_partnership! 
      if current_user.nil?
        redirect_to new_user_session_url
      elsif current_user.affiliate.nil?
        redirect_to root_url
      elsif current_user.affiliate.certific? && (current_user.role == 'worker')
        redirect_to root_url
      end
    end

    def authenticate_subscribed!
        if current_user.nil?
          redirect_to new_user_session_url
        end
#        else
#          unless (current_user && current_user.daycare.try(:active_subscription?)) || (current_user && current_user.partner?)          
#            #redirect_to implementation_url, alert: "You need to upgrade in order to access this feature"
#            redirect_to dashboard_url, alert: "You need to upgrade in order to access this feature"
#          end
#        end
    end

    def after_sign_in_path_for resource
      if resource.admin?
        admin_root_path
      elsif resource.partner?
        dashboard_path
      elsif resource.manager?
        dashboard_path
      elsif resource.medical_professional?
        if resource.collaborations.present?
          medical_professional_discussions_path
        else
          choose_child_invitation_path
        end
      else
        dashboard_path
      end
    end

    def after_sign_up_path_for resource
      if resource.admin?
        admin_root_path
      elsif resource.manager?
        invite_manager_daycares_path
      elsif resource.medical_professional?
        choose_child_invitation_path
      else
        dashboard_path
      end
    end

    def current_daycare
        @current_daycare ||= user_signed_in? ? current_user.daycare : nil
    end

  def archive_notification
    if params[:notification_id].present?
      @notification = Notification.find(params[:notification_id])
      @notification.archived!
    end
  end

end
