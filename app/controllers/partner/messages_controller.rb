class Partner::MessagesController < ApplicationController
  layout 'dashboard_v2'
  before_action -> {authenticate_role!(["partner", "worker"])}
  before_action :strategic_partnership!

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params.merge(owner_id: current_user.id))

    if @message.save
      if current_user.affiliate.certific?
        MessageNotificationJob.perform_now(@message, {partner: true, affiliate_id: current_user.affiliate.id})
      else
        MessageNotificationJob.perform_now(@message, {partner: true})
      end      
      redirect_to partner_messages_path, notice: 'Message successfully sent.'
    else
      redirect_to new_partner_message_path, notice: 'There was an error creating the message.'
    end
  end

  def list
    params[:page] ||= 1
    @messages = set_messages

    if request.xhr?
      render partial: '/messages/message_list'
    end
  end

  private

  def message_params
    params.require(:message).permit(
      :title,
      :content,
      target_roles: []
    )
  end

  def set_messages
    cond_str, cond_arr = set_query_conditions

    @messsages ||= Message.by_owner(current_user.id)
                 .where(cond_str, *cond_arr)
                 .order(created_at: :asc)
                 .page(params[:page])
  end

  def set_query_conditions
    cond_str = []
    cond_arr = []

    if params['start_date'].present?
      cond_str << 'created_at >= ?'
      cond_arr << Date.parse(params['start_date']) - 1
    end

    if params['end_date'].present?
      cond_str << 'created_at <= ? '
      cond_arr << Date.parse(params['end_date']) + 1
    end

    if params['target_role'].present?
      cond_str << '? = ANY (target_roles)'
      cond_arr << params['target_role']
    end

    [cond_str.join(' AND '), cond_arr]
  end


end
