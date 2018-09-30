class WebinarController < ApplicationController
  layout "register"
  
  def show
    @schedule = Schedule.find_by_token(params[:id])
    @meeting_user_daycare = ''
    unless @schedule.nil?
      @meeting_user = MeetingUser.where(email: @schedule.email).first
      unless @meeting_user.nil?        
        @meeting_user_daycare = @meeting_user.daycare_name
      else
        redirect_to '/login'
      end
    end
  end

  def authenticate
    user = User.find_by_email(params[:user][:email])
    if user.valid_password?(params[:user][:password])
      sign_in user
      redirect_to "/dashboard"
    else
      flash[:alert] = "wrong password"
      redirect_to :back
    end
  end

end
