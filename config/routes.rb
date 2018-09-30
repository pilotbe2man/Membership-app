Rails.application.routes.draw do

  get 'program', to: 'registers#index'
  post 'registration/create', to: 'registers#create'

  get 'payment', to: "payments#index"

  resources :webinar, only: :show
  patch "webinar/:id/authenticate", to: "webinar#authenticate", as: :authenticate_webinar

  mount Ckeditor::Engine => '/ckeditor'
  resources :locales do
    resources :translations, constraints: { :id => /[^\/]+/ }
  end
  resources :locale_posters, only: :create


  resources :message_subjects
    devise_for :users, skip: [:registrations, :sessions, :passwords]

    devise_scope :user do
        # session
        get 'login',                        to: 'users/sessions#new',           as: 'new_user_session'
        post 'login',                       to: 'users/sessions#create',        as: 'user_session'
        delete 'logout',                    to: 'users/sessions#destroy',       as: 'destroy_user_session'


        # passwords
        get 'password/new',                 to: 'users/passwords#new',          as: 'new_user_password'
        get 'password/edit',                to: 'users/passwords#edit',          as: 'edit_user_password'
        patch 'password',                   to: 'users/passwords#update',       as: 'user_password'
        post 'password',                    to: 'users/passwords#create'
        get 'password/select_daycare',      to: 'users/passwords#select_daycare', as: 'password_select_daycare'
        post 'password/check_email_exists',  to: 'users/passwords#check_email_exists', as: 'check_email_exists'
        get 'password/select_department',      to: 'users/passwords#select_department', as: 'password_select_department'

        # registrations
        get ':role/register',               to: 'users/registrations#new',      as: 'new_user_registration'
        post ':role/register',              to: 'users/registrations#create',   as: 'user_registration'
        post ':role/register_daycare',      to: 'users/registrations#daycare',  as: 'daycare_registration'
        post ':role/register_affiliate',    to: 'users/registrations#affiliate',as: 'affiliate_registration'
        post ':role/register_success',      to: 'users/registrations#success',  as: 'success_registration'

        #Meeting (Schedule Once)
        get '/schedule_meeting',            to: 'users/registrations#schedule_meeting', as: 'schedule_meeting'

        # edit
        get ':role/:id/edit',               to: 'users/registrations#edit',      as: 'edit_user_registration'
        get ':role/:id/edit_user',          to: 'users/registrations#edit_user', as: 'edit_user_info'
        put ':role/update_user',            to: 'users/registrations#update',    as: 'update_user_registration'
        patch ':role/update_daycare',       to: 'users/registrations#update_daycare',   as: 'update_daycare'

        # email verification
        get 'confirm_email/:id',            to: 'users/registrations#confirm_email',  as: 'confirm_email'
    end

    # custom registration routes
    scope 'worker', controller: 'users/workers' do
        get :select_type, as: 'worker_select_type'
        get :select_daycare, as: 'worker_select_daycare'
        get :select_department, as: 'worker_select_department'
        get :get_daycares, as: 'worker_get_daycares', :defaults => { :format => 'json' }
        post :update_daycare, as: 'worker_update_daycare', :defaults => { :format => 'json' }
        get :update_department, as: 'worker_update_department'
        post :change_department, as: 'worker_change_department', :defaults => { :format => 'json' }
    end

    # custom registration routes
    scope 'parentee', controller: 'users/parentees' do
        get :select_daycare, as: 'parentee_select_daycare'
    end

    root to: 'pages#home'

    get "ethic_5", to: "pages#ethic_5", as: "webinar_calendar"
    get "account_register", to: "pages#account_register", as: "account_register"

    %w( about mission path standard journey getting_started select_user_type welcome infection instruction implementation take_action ethic_1 ethic_2 ethic_3 ethic_4 description email_campaign pre_user_plan contact_us illness_guide).each do |page|
        get page, to: "pages##{page}"
    end

    post 'contact_us', to: 'pages#send_message'

    get 'dashboard', to: 'dashboard#index'

    get 'approve_notify_section', to: 'dashboard#approve_notify_section'
    get 'approve_notify_department', to: 'dashboard#approve_notify_department'
    get 'approve_notify', to: 'dashboard#approve_notify'
    get 'decline_notify', to: 'dashboard#decline_notify'
    get 'notify_list_section', to: 'dashboard#notify_list_section'

    get 'upgrade', to: 'subscriptions#index'
    get 'user_plan', to: 'subscriptions#user_plan'
    get 'set_userplan', to: 'subscriptions#set_userplan'

    post 'add_pending_option', to: 'survey_pending_option#new'
    get 'complete_pending_option/:user_id/:subject_id', to: 'survey_pending_option#complete', as: 'complete_pending_option'
    post 'guide_text', to: 'pages#guide_text', :defaults => { :format => 'json' }

    get 'get_available_schedule_time', to: 'pages#get_available_schedule_time', :defaults => { :format => 'json' }

    post 'add_schedule', to: 'pages#add_schedule'
    post 'get_discount_code', to: 'pages#get_discount_code', :defaults => { :format => 'json' }
    get  'guide_page/:page/:step', to: 'pages#guide_page' , as: 'guide_page'

    resources :plans, only: [] do
      resources :subscriptions, only: [:new, :create, :index] do
        get :complete, on: :member
      end
    end

    resources :transactions, only: [:create]

    namespace :manager do
        resources :todos do
            member do
                get :active
                get :inactive
            end

            collection do
                get :dashboard
                get :search
                get :select_department
                get :status_list
                post :sub_todos
            end
        end

        namespace :reports do
            namespace :todos do
                root action: 'index'
                get :search
            end
            resources :todos, only: [] do
                get :set_date_range
                get :select_todo_result
                get :show
            end
        end


        resources :survey_subjects, as: 'subjects', path: 'subjects', only: [] do
            get :results, on: :collection
            get :result, on: :member
            get :user_result, on: :member
            get :group_result, on: :member
        end

        resources :daycares, only: [] do
            collection do
                get :invite
                get 'invite_survey/:type', to: 'daycares#invite_survey', as: 'invite_survey'
                post :send_invites
                post :send_invite_survey
            end
        end

        resources :messages do
          collection do
            get  :select_department
            get  :recipient
            get  :subject
            post  :subject
            get  :sub_subject
            get  :content
          end
        end

        resources :illness_guides do
          collection do
            get  :role
            get  :illness
            get  :content
          end
        end

        resources :illnesses, only: [] do
          collection do
            get  :set_filters
            post :trends
          end
        end
    end

    namespace :worker do
        resources :illness_guides do
          collection do
            get  :role
            get  :illness
            get  :content
          end
        end
    end

    namespace :parentee do
        resources :illness_guides do
          collection do
            get  :role
            get  :illness
            get  :content
          end
        end
    end

    namespace :partner do
        resources :survey_subjects, as: 'subjects', path: 'subjects', only: [] do
            post :results, on: :collection
            get  :get_results, on: :collection
            post :result, on: :member
            post :daycare_result
            post :daycare_group_result
            get :group_result
            get :user_result
            get :select_daycare, on: :collection
            get :select_municipal, on: :collection
            get :select_date, on: :collection
        end

        resources :illnesses, only: [] do
          collection do
            get  :set_filters
            post :trends
            get :select_municipal
            post :municipal_trends
          end
        end

        resources :todos do
            collection do
                get :select_daycare
                get :select_municipal
                post :results
            end
            member do
                post :task_result
            end
        end

        resources :affiliates, only: [] do
            collection do
                get 'invite_member/:type', to: 'affiliates#invite_member', as: 'invite_member'
                get :invite_member
                post :send_invite_member
            end
        end
    end

    resources :permissions, only: []  do
      collection do
        get :section_a
        get :section_b
        get :task_status
        get :emergency
      end
    end

    resources :survey_subjects, as: 'subjects', path: 'subjects', only:[] do
        get :results, on: :collection
        get :result, on: :member
        resources :attempts, only: :new
        resources :surveys, only: [] do
            resources :attempts, only: :create
        end
    end

    resources :todos, only: [:index] do
        get :search, on: :collection
        resources :todo_completes, only: [:show, :create]
    end
    resources :todo_task_completes, only: :update
    resources :sub_task_completes, only: :update

    resources :trainings, only: :show

    resources :illnesses, only: [:index] do
      collection do
        get  :add_record
        get  :new_child_record
        get  :new_department_record
        get  :department_children
        get  :child_profile
        get  :symptoms
        get  :guides
        get  :department_workers
        get  :worker_profile
        get  :filter
        get  :filter_children
        get  ':record_type/list', to: 'illnesses#list', as: 'list'

        post :create_child_record
        post :create_department_record
      end
    end

    resources :health_records, only: [:show] do
      collection do
        get  :alert_records
      end
    end

    namespace :admin do
        root to: 'pages#lang_dashboard'

        #localization
        get 'lang_dashboard', to: 'pages#lang_dashboard'
        get 'lang_survey', to: 'pages#lang_survey'
        get 'lang_illness', to: 'pages#lang_illness'
        get 'lang_training', to: 'pages#lang_training'
        get 'lang_template', to: 'pages#lang_template'
        get 'lang_video', to: 'pages#lang_video'
        get 'lang_main', to: 'pages#lang_main'
        get 'list_message', to: 'pages#list_message'
        get 'list_invite', to: 'pages#list_invite'
        get 'list_verify', to: 'pages#list_verify'
        get 'list_confirm', to: 'pages#list_confirm'
        get 'download_yml', to: 'pages#download_yml'

        get 'clients', to: 'pages#clients'
        post 'localization', to: 'pages#upload'

        post 'send_verify', to: 'users#send_verify', format: 'json'
        get 'getUploadYmlStatus', to: 'pages#getUploadYmlStatus', format: 'json'
        get 'password', to: 'pages#password'
        post 'change_password', to: 'pages#change_password'

        authenticate :user, lambda { |u| u.admin? } do
            mount Sidekiq::Web => '/sidekiq'
        end
        resources :discount_codes, except: :show
        resources :payment_modes, except: :show
        resources :payment_starts, except: :show
        resources :plans, except: :show
        resources :global_settings, except: :show
        resources :todos
        resources :users, only: [:index, :destroy]
        resources :daycares
        resources :affiliates
        resources :departments, only: [:index, :destroy]
        resources :subjects, except: :show
        resources :message_subjects , only: [:index, :destroy]
        resources :message_templates do
          collection do
            get :subject
            get :sub_subject
            get :recipient
            get :edit_filters
            get :filter
            get :upload
            post :upload
          end
        end
        resources :message_templates_updates, except: :show
        resources :messages, only: [:new, :create]
        resources :illnesses

        resources :illnesses do
            match :upload, on: :collection, via: [:get, :post]
        end

        resources :survey_subjects do
            match :upload, on: :member, via: [:get, :post]
            resources :surveys
        end
        resources :videos, except: :show
        resources :manager_videos, except: :show
        resources :email_campaigns, except: :show
        resources :locale_logos, except: :show
        resources :locale_posters

        resources :permissions do
            collection do
                get :option
                get :group
                get :list
                get :daycares
                get :table
                post :change
                get :reset
                get :order
                post :change_order
                get :index
                get :order_all
            end
        end
        resources :illness_guide_updates
    end

    namespace :partner do
      resources :messages, only: [:index, :new, :create]
    end

    resources :messages, only: [] do
      get  :sub_subjects, on: :collection
    end

    namespace :api, constraints: { format: 'json' } do
      resources :daycares, only: [:index] do
        get :featured_daycare, on: :collection
        get :by_plan, on: :collection
      end
      resources :plans, only: :show

      resources :message_templates do
        get :filter_by, on: :collection
      end
    end
    resources :poster_email_users, only: [:index]

    get 'cast_vote', to: 'votes#cast_vote'

    get ':role/messages/:list_type/list', to: 'messages#list', as: 'list_messages'

    get 'path_2', to: 'pages#path_2'

    # Store data in Membership-app bucket
    post 'create_on_s3', to: 'admin/dashboard#create_on_s3'
end
