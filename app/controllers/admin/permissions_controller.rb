class Admin::PermissionsController < AdminController
    skip_before_filter :verify_authenticity_token, :only => [:change]

    def index
        set_permissions_by_type('all')
    end

    def option
    end

    def group
        if params[:daycare].nil? && params[:type].to_i == 1
            redirect_to daycares_admin_permissions_path(type: params[:type], option: params[:option])
        else
            get_type_label
            if params[:type].to_i == 1
                if params[:option].to_i > 1
                    get_daycare
                else
                    get_affiliate
                end
            end
        end
    end

    def daycares
        if params[:type].to_i == 0
            redirect_to group_admin_permissions_path(type: params[:type], option: params[:option])
        else
            get_type_label
            if params[:option].to_i > 1
                get_daycares
            else
                get_affiliates
            end
        end
    end

    def list
        get_type_label
        get_group_label

        if params[:type].to_i == 1
            if params[:option].to_i < 2
                get_affiliate
                [0, 1, 2, 3, 4, 5, 6].each do |ix|
                    permission = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, feature: ix, partner_id: params[:daycare])
                    if permission.length == 0
                        permission = Permission.find_or_create_by(sub_type: params[:option].to_i, member_type: params[:group].to_i, feature: ix, active: true, partner_id: params[:daycare])
                    end
                end

                @permissions = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, partner_id: params[:daycare]).order(:feature);
            else
                get_daycare
                [0, 1, 2, 3, 4, 5, 6].each do |ix|
                    permission = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, feature: ix, daycare_id: params[:daycare])
                    if permission.length == 0
                        permission = Permission.find_or_create_by(sub_type: params[:option].to_i, member_type: params[:group].to_i, feature: ix, active: true, daycare_id: params[:daycare])
                    end
                end

                @permissions = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, daycare_id: params[:daycare]).order(:feature);
            end
        else
            [0, 1, 2, 3, 4, 5, 6].each do |ix|
                permission = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, feature: ix, daycare_id: 0, partner_id: 0)
                if permission.length == 0
                    permission = Permission.find_or_create_by(sub_type: params[:option].to_i, member_type: params[:group].to_i, feature: ix, active: true, daycare_id: 0, partner_id: 0)
                end
            end

            @permissions = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, daycare_id: 0, partner_id: 0).order(:feature);
        end
    end

    def change
        initial_permissions

        params[:id].each_with_index do |item, ix|
            permission = Permission.find(item)
            permission.active       = (params["feature_#{permission.id}"].nil?) ? false : true
            permission.plan         = params[:plan][ix] if params[:option].to_i > 1
            permission.plan_deposit = params[:plan_deposit][ix] if params[:option].to_i > 1

            result = get_permission_info(permission.member_type, permission.feature, permission.sub_type)

            permission.path         = result[:path]
            permission.guide_path   = result[:guide_path]
            permission.element      = result[:element]
            permission.image        = result[:image]
            permission.label_key    = result[:label_key]
            permission.save
        end

        redirect_to option_admin_permissions_path
    end

    def table
        @permissions = Permission.where(daycare_id: 0, partner_id: 0, active: true, sub_type: [0, 1, 2]).order(:sub_type, :created_at)
    end

    def reset
        Permission.all.delete_all
        redirect_to table_admin_permissions_path
    end

    def order
        @type = 'manager'
        @type = params['type'] if params['type'].present?
        set_permissions_by_type(@type)
    end

    def change_order
        if params[:permissions].present?
            params[:permissions].each do |p_params|
                p_params = p_params.last
                permission = Permission.find(p_params['id'])
                if permission.present?
                    permission.order = p_params['order']
                    permission.section = p_params['section']
                    permission.save
                end
            end
        end
        redirect_to action: 'index'
    end

    def order_all
        Permission.all.each do |permission|
            case permission.feature
            when 'survey'
                permission.order = 1
                permission.section = 'a'
            when 'online_training'
                permission.order = 2
                permission.section = 'a'
            when 'todo'
                permission.order = 3
                permission.section = 'a'
            when 'emergency'
                permission.order = 4
                permission.section = 'b'
            when 'illness_record'
                permission.order = 5
                permission.section = 'b'
            when 'illness_guide'
                permission.order = 6
                permission.section = 'b'
            when 'message'
                permission.order = 7
                permission.section = 'b'
            when 'todo-b'
                permission.order = 8
                permission.section = 'b'
            when 'illness_analysics'
                permission.order = 8
                permission.section = 'b'
            end
            permission.save
        end
        redirect_to admin_permissions_path, notice: t('permissions.order_set')
    end

    private
        def set_permissions_by_type(type)
            case type
            when 'manager'
                @permissions = Permission.where(member_type: 0).order(:created_at)
            when 'worker'
                @permissions = Permission.where(member_type: 1).order(:created_at)
            when 'parentee'
                @permissions = Permission.where(member_type: 2).order(:created_at)
            when 'partner'
                @permissions = Permission.where(member_type: 3).order(:created_at)
            else
                @manager_permissions = Permission.where(member_type: 0).order(:created_at)
                @worker_permissions = Permission.where(member_type: 1).order(:created_at)
                @parentee_permissions = Permission.where(member_type: 2).order(:created_at)
                @partner_permissions = Permission.where(member_type: 3).order(:created_at)
            end

        end
        def initial_permissions
            if params[:daycare].blank?
                @permissions = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, daycare_id: 0, partner_id: 0);
            else
                if params[:option].to_i > 1
                    @permissions = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, daycare_id: params[:daycare]);
                else
                    @permissions = Permission.where(sub_type: params[:option].to_i, member_type: params[:group].to_i, partner_id: params[:daycare]);
                end
            end

            @permissions.each do |item|
                item.active = false
                item.save
            end
        end

        def get_type_label
            @type_label = ''
            case params[:option]
            when '0'
                @type_label = "Certification Partnership"
            when '1'
                @type_label = "Healthier and Safer Childcare Partnership"
            when '2'
                @type_label = "Chain Daycare"
            when '3'
                @type_label = "Independant Daycare"
            when '4'
                @type_label = "Govermantal Daycare"
            end
        end

        def get_group_label
            @group_label = ''
            case params[:group]
            when '0'
                @group_label = "Daycare Manager"
            when '1'
                @group_label = "Daycare Worker"
            when '2'
                @group_label = "Daycare Parent"
            when '3'
                @group_label = "Partner"
            end
        end

        def get_affiliate
            @affiliate = Affiliate.find(params[:daycare])
        end

        def get_daycare
            @daycare = Daycare.find(params[:daycare])
        end

        def get_affiliates
            @affiliates = Affiliate.where(affiliate_type: params[:option])
        end

        def get_daycares
            care_type = 0
            case params[:option]
            when '0'
                care_type = 0
            when '1'
                care_type = 0
            when '2'
                care_type = 1
            when '3'
                care_type = 2
            when '4'
                care_type = 3
            end

            if care_type == 0
                @daycares = Daycare.all
            else
                @daycares = Daycare.where(care_type: care_type)
            end
        end

        def get_permission_info(member_type, feature, sub_type = '')
            result = {
                path: '',
                guide_path: '',
                element: '',
                image: '',
                label_key: ''
            }
            case feature
            # Survey
            when 'survey'
                case member_type
                # manager
                when 'manager'
                    result[:path] = results_manager_subjects_path
                    result[:guide_path] = '/guide_page/manager_survey/result_step1'
                # worker
                when 'worker'
                    if (sub_type == 0)
                        result[:path] = select_daycare_partner_subjects_path
                        result[:guide_path] = '#'
                    else
                        result[:path] = results_subjects_path
                        # result[:guide_path] = '/guide_page/worker_survey/take_step1'
                        result[:guide_path] = '#'
                    end
                # parent
                when 'parentee'
                    result[:path] = results_subjects_path
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = (sub_type == 1) ? get_results_partner_subjects_path : select_municipal_partner_subjects_path
                    result[:guide_path] = '#'
                end
                result[:element] = 'item_survey'
                result[:image] = 'dashboard-risk.png'
                result[:label_key] = 'dashboard.menu_item.risk_assessment'
            # online_training
            when 'online_training'
                result[:path] = instruction_path
                # result[:guide_path] = instruction_path
                result[:guide_path] = '#'

                result[:element] = 'item_instruction'
                result[:image] = 'dashboard-instruction.png'
                result[:label_key] = 'dashboard.menu_item.instruction'
            # message
            when 'message'
                case member_type
                # manager
                when 'manager'
                    result[:path] = manager_messages_path
                    # result[:guide_path] = '/guide_page/manager_message/dash'
                    result[:guide_path] = '#'
                # worker
                when 'worker'
                    if (sub_type == 0)
                        result[:path] = partner_messages_path
                        result[:guide_path] = '#'
                    else
                        result[:path] = list_messages_path(role: 'worker', list_type: 'received')
                        result[:guide_path] = '#'
                    end
                # parent
                when 'parentee'
                    result[:path] = list_messages_path(role: 'parentee', list_type: 'received')
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = partner_messages_path
                    result[:guide_path] = '#'
                end

                result[:element] = 'item_message'
                result[:image] = 'dashboard-com-mng.png'
                result[:label_key] = 'dashboard.menu_item.communication'
            # todo
            when 'todo'
                case member_type
                # manager
                when 'manager'
                    result[:path] = dashboard_manager_todos_path
                    # result[:guide_path] = '/guide_page/manager_todo/dash'
                    result[:guide_path] = '#'
                # worker
                when 'worker'
                    if (sub_type == 0)
                        result[:path] = select_daycare_partner_todos_path
                        result[:guide_path] = '#'
                    else
                        result[:path] = todos_path
                        # result[:guide_path] = '/guide_page/worker_todo/todo_step1'
                        result[:guide_path] = '#'
                    end
                # parent
                when 'parentee'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = (sub_type == 1) ? '#' : select_municipal_partner_todos_path
                    result[:guide_path] = '#'
                end

                result[:element] = 'item_todo'
                result[:image] = 'dashboard-taskmng.png'
                result[:label_key] = 'dashboard.menu_item.task_manager'
            # illness_analysics
            when 'illness_analysics'
                case member_type
                # manager
                when 'manager'
                    result[:path] = set_filters_manager_illnesses_path
                    # result[:guide_path] = '/guide_page/manager_illness/graph_step1'
                    result[:guide_path] = '#'
                # worker
                when 'worker'
                    if (sub_type == 0)
                        result[:path] = set_filters_partner_illnesses_path
                        result[:guide_path] = '#'
                    else
                        result[:path] = '#'
                        result[:guide_path] = '#'
                    end
                # parent
                when 'parentee'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = select_municipal_partner_illnesses_path
                    result[:guide_path] = '#'
                end

                result[:element] = 'item_illness_graph'
                result[:image] = 'dashboard-illness-graph.png'
                result[:label_key] = 'dashboard.menu_item.illness_analytic'
            # illness_record
            when 'illness_record'
                case member_type
                # manager
                when 'manager'
                    result[:path] = filter_illnesses_path
                    # result[:guide_path] = '/guide_page/worker_illness/view_dash'
                    result[:guide_path] = '#'
                # worker
                when 'worker'
                    if (sub_type == 0)
                        result[:path] = '#'
                        result[:guide_path] = '#'
                    else
                        result[:path] = illnesses_path
                        # result[:guide_path] = '/guide_page/worker_illness/view_dash'
                        result[:guide_path] = '#'
                    end
                # parent
                when 'parentee'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                end

                result[:element] = 'item_illness'
                result[:image] = 'dashboard-ilness.png'
                result[:label_key] = 'dashboard.menu_item.illness_record'
            # illness_guide
            when 'illness_guide'
                case member_type
                # manager
                when 'manager'
                    result[:path] = illness_manager_illness_guides_path
                    # result[:guide_path] = '/guide_page/worker_illness/view_dash'
                    result[:guide_path] = '#'
                # worker
                when 'worker'
                    if (sub_type == 0)
                        result[:path] = '#'
                        result[:guide_path] = '#'
                    else
                        result[:path] = illness_worker_illness_guides_path
                        # result[:guide_path] = '/guide_page/worker_illness/view_dash'
                        result[:guide_path] = '#'
                    end
                # parent
                when 'parentee'
                    result[:path] = illness_parentee_illness_guides_path
                    result[:guide_path] = '#'
                # partner
                when 'partner'
                    result[:path] = '#'
                    result[:guide_path] = '#'
                end

                result[:element]    = 'item_illness_guide'
                result[:image]      = 'dashboard-ilness-rec.png'
                result[:label_key]  = 'dashboard.menu_item.illness_guide'
            end
            return result
        end
end
