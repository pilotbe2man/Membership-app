class PermissionsController < ApplicationController
    layout 'sections'
    before_action :authenticate_subscribed!

    def section_a
      get_permissions('a')
      set_notifications
      set_videos('a')
      render "permissions/#{current_user.role}/section_a"
    end

    def section_b
      get_permissions('b')
      set_notifications
      set_videos('b')
      render "permissions/#{current_user.role}/section_b"
    end

    def task_status
      get_permissions('b')
      set_notifications
      render "permissions/#{current_user.role}/task_status"
    end

    def emergency
      render "permissions/#{current_user.role}/emergency"
    end

    private

    def get_permissions(section)
      group = 0
      sub_type = current_user.daycare.care_type + 1 rescue 1
      daycare_id = current_user.daycare.id rescue 0
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
          sub_type = current_user.daycare.care_type + 1 rescue 1
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

      @features = ['survey', 'online_training', 'todo']
      numbers = [1,2,3]
      numbers = [4, 5, 6, 7, 8, 9] if section == 'b'


      unless current_user.daycare.nil?
        @permissions = Permission.where(section: section, member_type: group, sub_type: sub_type, daycare_id: daycare_id, order: numbers).order(:order)
        if @permissions.blank?
          @permissions = Permission.where(section: section, member_type: group, sub_type: sub_type, daycare_id: 0, order: numbers).order(:order)
        end
      else
        @permissions = Permission.where(section: section, member_type: group, sub_type: sub_type, partner_id: daycare_id, order: numbers).order(:order)
        if @permissions.blank?
          @permissions = Permission.where(section: section, member_type: group, sub_type: sub_type, partner_id: 0, order: numbers).order(:order)
        end
      end

      if section == 'b' && (current_user.role == 'manager' || current_user.role == 'worker')
        if current_user.role == 'manager'
          @permissions.unshift(Permission.new(
            active: true, element: 'item_feature', feature: 'emergency', label_key: 'dashboard.notifications.record_alert',
            path: emergency_permissions_path))
        end
        last_permission = @permissions.last
        @permissions = @permissions.reverse.drop(1).reverse
        @permissions.push(Permission.new(
          active: true, element: 'item_todo-b', feature: 'todo-b', label_key: 'dashboard.notifications.status_of_task',
          path: task_status_permissions_path))
        @permissions.push(last_permission)
      end
    end

    def set_notifications
      @notifications ||= current_user.notifications.unread
      @notifications_by_sender ||= Notification.count_by_owner(current_user.id)
    end

    def set_videos(section = 'a')
      video_types = ['survey', 'online_training', 'todo']
      video_types = ['emergency', 'illness_record', 'illness_guide', 'message', 'todo-b', 'illness_analysics'] if section == 'b'
      category = 'paid'
      case current_user.role
      when 'manager'
        category = 'free' if !current_user.is_trial_member? && (!current_user.active_subscribed?)
      when 'parentee'
        category = 'free' if current_user.manager_is_non_paid?
      when 'worker'
        category = 'free' if current_user.manager_is_non_paid?
      when 'partner'
        category = 'free' unless (current_user.affiliate.certific? && current_user.paid_plan_type > 0)
      end
      @videos = ManagerVideo.where(video_type: video_types, category: category)
    end
end
