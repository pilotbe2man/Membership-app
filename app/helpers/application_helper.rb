module ApplicationHelper

    def custom_link_to_remove_fields name, f, opts={}
        f.hidden_field(:_destroy) + __custom_link_to_function(name, "remove_fields(this)", 'red', class: opts[:class])
    end

    def custom_link_to_remove_fields_alone name, opts={}
        __custom_link_to_function(name, "remove_fields(this)", 'red', class: opts[:class])
    end

    def custom_link_to_remove_subtask_fields f, opts={}
      f.hidden_field(:_destroy) + link_to(content_tag(:i, '', class: 'icon-cross icon-close'), 'javascript:void(0)', {onclick: "remove_fields(this)", class: 'subtask-link'})
    end

    def custom_link_to_add_fields name, f, association, opts={}
        new_object = f.object.class.reflect_on_association(association).klass.new
        new_object.build_profile_image if association == :children
        fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
            render(association.to_s.singularize + "_fields", :f => builder)
        end
        __custom_link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", 'green', class: opts[:class])
    end

    # Creates a JavaScript tag, targeting the associated JavaScript file within the asset pipeline
    # This method is used for page specific JavaScript files
    #
    # @overload set(value)
    #   @param [String] javascript file name
    # @return [String] javascript tags
    def javascript location, *files
        content_for(location) { javascript_include_tag(*files) }
    end

    # Create a new object to start building breadcrumbs for the administration area
    #
    # @return [Object] breadcrumbs for the current page in the administration area
    def create_admin_breadcrumbs
        @admin_breadcrumbs ||= [ { :title => 'Healthier Childcare', :url => admin_root_path}]
    end


    # Create a new object to start building breadcrumbs for the administration area
    #
    # @return [Object] breadcrumbs for the current page in the administration area
    def create_manager_breadcrumbs(current_path)
      case current_path
      when section_a_permissions_path
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
        ]
      when section_b_permissions_path
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
        ]
      when "/manager/subjects/results"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_a'), :url => section_a_permissions_path},
        ]
      when "/instruction"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_a'), :url => section_a_permissions_path},
        ]
      when "/manager/todos/dashboard"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_a'), :url => section_a_permissions_path},
        ]
      when "/manager/todos/new"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_a'), :url => section_a_permissions_path},
          { :title => t('manager.todos.labels.task_manager'), :url => dashboard_manager_todos_path},
        ]
      when "/manager/todos/status_list"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_a'), :url => section_a_permissions_path},
          { :title => t('manager.todos.labels.task_manager'), :url => dashboard_manager_todos_path},
        ]
      when "/manager/todos"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_a'), :url => section_a_permissions_path},
          { :title => t('manager.todos.labels.task_manager'), :url => dashboard_manager_todos_path},
        ]
      when "/manager/reports/todos"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_a'), :url => section_a_permissions_path},
          { :title => t('manager.todos.labels.task_manager'), :url => dashboard_manager_todos_path},
        ]
      when emergency_permissions_path
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
        ]
      when "/illnesses/filter"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
        ]
      when "/manager/illness_guides/illness"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
        ]
      when "/manager/illness_guides/illness"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
        ]
      when task_status_permissions_path
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
        ]
      when "/manager/messages"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
        ]
      when "/manager/illnesses/set_filters"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
        ]
      when "/manager/illness_guides/content"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
          { :title => t('illness_guides.illness'), :url => illness_manager_illness_guides_path},
        ]
      when "/manager/messages/select_department"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
          { :title => t('messages.breadcrumb.message'), :url => manager_messages_path}
        ]
      when "/manager/messages/recipient"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
          { :title => t('messages.breadcrumb.message'), :url => manager_messages_path},
          { :title => t('messages.breadcrumb.message_options'), :url => select_department_manager_messages_path(target_department: params[:target_department])}
        ]
      when "/manager/messages/subject"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
          { :title => t('messages.breadcrumb.message'), :url => manager_messages_path},
          { :title => t('messages.breadcrumb.message_options'), :url => select_department_manager_messages_path(target_department: params[:target_department])},
          { :title => t('messages.breadcrumb.choose_recipient'), :url => recipient_manager_messages_path(target_department: params[:target_department], target_role: params[:target_role])}
        ]
      when "/manager/messages/sub_subject"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
          { :title => t('messages.breadcrumb.message'), :url => manager_messages_path},
          { :title => t('messages.breadcrumb.message_options'), :url => select_department_manager_messages_path(target_department: params[:target_department])},
          { :title => t('messages.breadcrumb.choose_recipient'), :url => recipient_manager_messages_path(target_department: params[:target_department], target_role: params[:target_role])},
          { :title => t('messages.breadcrumb.choose_subject'), :url => subject_manager_messages_path(target_department: params[:target_department], target_role: params[:target_role], subject_id: params[:subject_id])}
        ]
      when "/manager/messages/content"
        @manager_breadcrumbs = [
          { :title => 'Home', :url => dashboard_path},
          { :title => t('permissions.section_b'), :url => section_b_permissions_path},
          { :title => t('messages.breadcrumb.message'), :url => manager_messages_path},
          { :title => t('messages.breadcrumb.message_options'), :url => select_department_manager_messages_path(target_department: params[:target_department])},
          { :title => t('messages.breadcrumb.choose_recipient'), :url => recipient_manager_messages_path(target_department: params[:target_department], target_role: params[:target_role])},
          { :title => t('messages.breadcrumb.choose_subject'), :url => subject_manager_messages_path(target_department: params[:target_department], target_role: params[:target_role], subject_id: params[:subject_id])},
          { :title => t('messages.breadcrumb.choose_sub_subject'), :url => sub_subject_manager_messages_path(target_department: params[:target_department], target_role: params[:target_role], subject_id: params[:subject_id], sub_subject_id: params[:sub_subject_id])}
        ]
      else
        @manager_breadcrumbs = nil
      end
    end

    # Add a new breadcrumb to the administration area breadcrumb object using the parameters
    #
    # @param title [String]
    # @param url [String]
    def breadcrumb_add title, url
        create_admin_breadcrumbs << { :title => title, :url => url }
    end

    # Renders the HTML elements for the breadcrumbs
    #
    # @param type [Integer]
    # @return [String] HTML elements
    def render_breadcrumbs type
        if type == 0
            render partial: 'shared/admin/breadcrumbs', locals: { breadcrumbs: create_admin_breadcrumbs }
        else
            render partial: theme_presenter.page_template_path('shared/admin/breadcrumbs'), locals: { breadcrumbs: create_store_breadcrumbs }
        end
    end

    # If the string parameter equals the current controller value in the parameters hash, return a string
    #
    # @param controller [String]
    # @param action [String]
    # @return [String] class name for a HTML element
    def active_controller? data
        if data[:action].nil?
            "current" if params[:controller] == data[:controller]
        else
            "current" if params[:controller] == data[:controller] && params[:action] == data[:action]
        end
    end

    def yield_js_translations
      trans = {}

      locale_logo = LocaleLogo.find_by(language: I18n.locale.upcase)

      trans['featured_daycare'] = (locale_logo.nil? || locale_logo.upgrade_notifier.blank?) ? I18n.t('notifications.featured_daycare') : locale_logo.upgrade_notifier
      trans['featured_daycare_by_plan'] = (locale_logo.nil? || locale_logo.upgrade_notifier.blank?) ? I18n.t('notifications.featured_daycare_by_plan') : locale_logo.upgrade_notifier
      trans['no_template_for_role'] = I18n.t('messages.notifications.no_template_for_role')
      trans['invalid_template_file'] = I18n.t('messages.notifications.invalid_template_file')
      trans['required_filter_role'] = I18n.t('messages.notifications.required_filter_role')
      trans['required_filter_subject'] = I18n.t('messages.notifications.required_filter_subject')
      trans['required_filter_sub_subject'] = I18n.t('messages.notifications.required_filter_sub_subject')
      trans['required_dept_filter'] = I18n.t('illnesses.labels.required_dept_filter')
      trans['required_child_filter'] = I18n.t('illnesses.labels.required_child_filter')
      trans['worker_progress_chart_title'] = I18n.t('survey.labels.worker_progress_chard_title')
      trans
    end

  def current_user_role_avatar
    if current_user.manager?
      'manager-md.png'
    elsif current_user.parentee?
      'parent-md.png'
    elsif current_user.worker?
      'worker-md.png'
    elsif current_user.partner?
      (!current_user.affiliate.nil? && current_user.affiliate.profile_image) ? current_user.affiliate.profile_image.file.url : 'partner-md.png'
    elsif current_user.admin?
      'super-admin.png'
    elsif current_user.medical_professional?
      current_user.user_profile.profile_image.present? ? current_user.user_profile.profile_image.file.url : 'doctor.png'
    else
      'logo_menu.png'
    end
  end

  def pretty_long_date(date)
    date.strftime('%d/%m/%Y') + ' @ ' + date.strftime('%r')
  end

  def pretty_short_date(date)
    date.strftime('%d/%m/%Y')
  end

  def get_active_link(current_action)
    'active' if action_name == current_action
  end

  def get_video_link(cat, type, lang)
    video = Video.where(category: cat, video_type: type, language: lang.upcase).last
    url = '';
    url = video.url unless video.nil?
    url = url.gsub(/https\:\/\/drive.google.com\/open\?id=(.*)/, "https://drive.google.com/file/d/\\1/preview")
    return url
  end

  def assign_plan_list
    plan_list = []
    Plan.where(language: I18n.locale.upcase).order(:plan_type).each do |item|
      unless item.plan_type == 0 || item.plan_type == 1
        plan_list << [item.name, item.plan_type]
      end
    end
    return plan_list
  end

  def assign_discount_list
    discount_list = []
    discount_list << ['Select Discount', '']
    DiscountCode.active.each do |item|
      discount_list << [item.code, item.code]
    end
    return discount_list
  end

  def municipal_list(state = '')
    municipal_list = []
    Municipal.where(language: I18n.locale.downcase, state: state.upcase).each do |item|
      municipal_list << [item.name, item.id]
    end
    return municipal_list
  end

  def get_remain_time todo_id
    todo = Todo.find_by(id: todo_id)
    cur_time = DateTime.now
    if todo.single?
      if todo.todo_completes.where.not(completion_date: nil).last.nil?
        start_time = todo.created_at
      else
        start_time = todo.todo_completes.where.not(completion_date: nil).last.completion_date
      end
      if start_time.nil?
        return [-1, -1, -1, -1]
      else
        return __release(start_time + todo.completion_time_value)
      end
    else
      start_time = todo.start_date
      if todo.day?
        if !start_time.nil? && start_time - cur_time > 0
          return __release(start_time)
        else
          return __release(Date.tomorrow.to_time)
        end
      elsif todo.week?
        if start_time.nil?
          return [-1, -1, -1, -1]
        end

        start_days = (todo.start_days.nil?) ? "[]" : todo.start_days
        weekdays = JSON.parse(start_days)
        cur_wday = start_time.strftime("%w").to_i
        passed = 0
        next_start_time  = ''
        weekdays.each do |wday|
          if wday.to_i > cur_wday.to_i
            diff_day = wday.to_i - cur_wday.to_i
            next_start_time = diff_day.days.from_now
            passed = 1
            break
          end
        end

        if passed == 0
          weekdays.each do |wday|
            if wday.to_i + 7> cur_wday.to_i
              diff_day = wday.to_i - cur_wday.to_i + 7
              next_start_time = diff_day.days.from_now
              passed = 1
              break
            end
          end
        end
        return __release(next_start_time.to_date.to_time)
      else
        if !start_time.nil? && start_time - cur_time > 0
          return __release(start_time)
        else
          if start_time.nil?
            return [-1, -1, -1, -1]
          end
          day = start_time.strftime("%d").to_i
          next_start_time = DateTime.new(Time.now.year,Time.now.month,day,0,0,0)
          if next_start_time - cur_time > 0
            return __release(next_start_time.to_time)
          else
            next_start_time = DateTime.new(Time.now.year,Time.now.month,day,0,0,0)
            return __release((next_start_time + 1.months).to_time)
          end
        end
      end
    end
    [0, 0, 0, 0]
  end

  def get_current_status todo_id, department_id
    between_date = __get_in_time(todo_id)
    todo_completes = TodoComplete.generate_report(todo_id, between_date[0], between_date[1], department_id)
    report = TodoReporter.new(todo_completes: todo_completes, task_id: 0).percentages
    return report[:complete].round
  end

    private

      def __get_in_time todo_id
        todo = Todo.find_by(id: todo_id)
        cur_time = DateTime.now
        if todo.single?
          start_time = todo.start_date
          if todo.todo_completes.where.not(completion_date: nil).last.nil?
            if start_time.nil?
              return [cur_time, cur_time]
            else
              return [start_time, cur_time]
            end
          else
            return [todo.todo_completes.where.not(completion_date: nil).last.completion_date, cur_time]
          end
        else
          start_time = todo.start_date
          if todo.day?
            if !start_time.nil? && start_time - cur_time > 0
              return [cur_time, start_time]
            else
              return [Date.yesterday.to_time, cur_time]
            end
          elsif todo.week?
            if start_time.nil?
              return [cur_time, cur_time]
            end

            start_days = (todo.start_days.nil?) ? "[]" : todo.start_days
            weekdays = JSON.parse(start_days)
            cur_wday = start_time.strftime("%w").to_i
            passed = 0
            next_start_time  = ''
            prev_start_time  = ''
            weekdays.each_with_index do |wday, index|
              if wday.to_i > cur_wday.to_i
                diff_day = wday.to_i - cur_wday.to_i
                prev_diff_day = cur_wday.to_i - weekdays[index - 1].to_i
                next_start_time = diff_day.days.from_now
                prev_start_time = prev_diff_day.days.ago
                passed = 1
                break
              end
            end

            if passed == 0
              weekdays.each_with_index do |wday, index|
                if wday.to_i + 7> cur_wday.to_i
                  diff_day = wday.to_i - cur_wday.to_i + 7
                  prev_diff_day = cur_wday.to_i - weekdays[index - 1].to_i
                  next_start_time = diff_day.days.from_now
                  prev_start_time = prev_diff_day.days.ago
                  passed = 1
                  break
                end
              end
            end
            return [prev_start_time.to_date.to_time, next_start_time.to_date.to_time]
          else
            if !start_time.nil? && start_time - cur_time > 0
              return [cur_time, start_time]
            else
              if start_time.nil?
                return [cur_time, cur_time]
              end
              day = start_time.strftime("%d").to_i
              next_start_time = DateTime.new(Time.now.year,Time.now.month,day,0,0,0)
              if next_start_time - cur_time > 0
                return [(next_start_time - 1.months).to_time, next_start_time.to_time]
              else
                next_start_time = DateTime.new(Time.now.year,Time.now.month,day,0,0,0)
                return [next_start_time.to_time, (next_start_time + 1.months).to_time]
              end
            end
          end
        end
      end

    def __release(time)
      delta = time - Time.now

      %w[days hours minutes seconds].collect do |step|
        seconds = 1.send(step)
        (delta / seconds).to_i.tap do
          delta %= seconds
        end
      end
    end

    def __custom_link_to_function name, on_click_event, button_color, opts={}
        link_to(name, 'javascript:void(0);', {onclick: on_click_event, class: "btn btn-#{button_color} btn-normal #{opts[:class]}"})
    end
end
