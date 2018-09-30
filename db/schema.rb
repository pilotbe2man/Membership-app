# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180923105107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "affiliates", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "postcode"
    t.string   "country"
    t.string   "telephone"
    t.datetime "deactivated_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "url"
    t.integer  "affiliate_type", default: 0
    t.integer  "num_member",     default: 0
    t.integer  "municipal_id"
  end

  add_index "affiliates", ["name"], name: "index_affiliates_on_name", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "deactivated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "back_job_statuses", force: :cascade do |t|
    t.string   "job_type"
    t.boolean  "job_status"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "child_collaborators", force: :cascade do |t|
    t.integer  "child_id"
    t.integer  "collaborator_id"
    t.string   "collaborator_type"
    t.datetime "deactivated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "child_collaborators", ["child_id"], name: "index_child_collaborators_on_child_id", using: :btree

  create_table "children", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "department_id"
    t.datetime "birth_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "collaboration_invites", force: :cascade do |t|
    t.integer "child_id"
    t.integer "inviter_id"
    t.string  "invitee_email"
    t.integer "status",        default: 0
    t.string  "invite_code"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "discussion_id"
    t.integer  "owner_id"
    t.string   "content"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "comments", ["discussion_id"], name: "index_comments_on_discussion_id", using: :btree
  add_index "comments", ["owner_id"], name: "index_comments_on_owner_id", using: :btree

  create_table "daycares", force: :cascade do |t|
    t.string   "name"
    t.string   "address_line1"
    t.string   "postcode"
    t.string   "country"
    t.string   "telephone"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "url"
    t.integer  "num_children"
    t.integer  "num_worker"
    t.integer  "care_type"
    t.integer  "discount_code_id", default: 0
    t.integer  "payment_month",    default: 0
    t.integer  "payment_mode_id"
    t.integer  "payment_start_id"
    t.integer  "municipal_id"
    t.integer  "pay_mode",         default: 1
  end

  create_table "department_todos", force: :cascade do |t|
    t.integer  "todo_id"
    t.integer  "department_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "todo_active",   default: true
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "daycare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_code_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "discount_code_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "discount_codes", force: :cascade do |t|
    t.string   "code"
    t.integer  "value",      default: 0
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "discussion_participants", force: :cascade do |t|
    t.integer  "discussion_id"
    t.integer  "participant_id"
    t.string   "participant_type"
    t.boolean  "initiator"
    t.datetime "deactivated_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "discussion_participants", ["discussion_id"], name: "index_discussion_participants_on_discussion_id", using: :btree

  create_table "discussions", force: :cascade do |t|
    t.string   "title"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "owner_id"
    t.string   "content"
  end

  add_index "discussions", ["subject_type", "subject_id"], name: "index_discussions_on_subject_type_and_subject_id", using: :btree

  create_table "doctor_specializations", force: :cascade do |t|
    t.integer  "user_profile_id"
    t.integer  "medical_specialization_id"
    t.datetime "deactivated_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "email_campaigns", force: :cascade do |t|
    t.string   "subject"
    t.string   "content"
    t.string   "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "global_settings", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "health_record_components", force: :cascade do |t|
    t.integer  "health_record_id"
    t.string   "code"
    t.string   "value"
    t.datetime "deactivate_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "health_record_components", ["health_record_id"], name: "index_health_record_components_on_health_record_id", using: :btree

  create_table "health_records", force: :cascade do |t|
    t.string   "protocol_code"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "recorder_id"
    t.string   "recorder_type"
    t.datetime "deactivated_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "daycare_id"
    t.integer  "department_id"
    t.integer  "alert_status",   default: 0
  end

  create_table "illness_guide_updates", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "illness_guides", force: :cascade do |t|
    t.integer  "illness_id"
    t.string   "content"
    t.string   "language"
    t.string   "ref_id"
    t.integer  "target_role"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "illnesses", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "language"
    t.string   "ref_id"
    t.string   "worker_guide_file_name"
    t.string   "worker_guide_content_type"
    t.integer  "worker_guide_file_size"
    t.datetime "worker_guide_updated_at"
    t.string   "parent_guide_file_name"
    t.string   "parent_guide_content_type"
    t.integer  "parent_guide_file_size"
    t.datetime "parent_guide_updated_at"
    t.string   "description"
  end

  create_table "locale_files", force: :cascade do |t|
    t.string   "name"
    t.string   "preview_link"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "online_training_file_name"
    t.string   "online_training_content_type"
    t.integer  "online_training_file_size"
    t.datetime "online_training_updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "language_name"
    t.string   "language_short_name"
    t.string   "email_list_template_file_name"
    t.string   "email_list_template_content_type"
    t.integer  "email_list_template_file_size"
    t.datetime "email_list_template_updated_at"
    t.integer  "elem_type"
  end

  create_table "locale_logos", force: :cascade do |t|
    t.integer  "logo_type"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "language"
    t.string   "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "address1"
    t.string   "address2"
    t.string   "email"
    t.string   "phone_number"
    t.string   "title"
    t.string   "copyright"
    t.string   "upgrade_notifier"
    t.string   "invitation_notifier"
    t.string   "app_title"
  end

  create_table "locale_posters", force: :cascade do |t|
    t.string   "poster_type"
    t.string   "poster_file_name"
    t.string   "poster_content_type"
    t.integer  "poster_file_size"
    t.datetime "poster_updated_at"
    t.string   "language"
    t.string   "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "title"
    t.string   "button"
  end

  create_table "locale_urls", force: :cascade do |t|
    t.string   "url"
    t.string   "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "manager_videos", force: :cascade do |t|
    t.string   "url"
    t.string   "language"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "video_type"
  end

  create_table "medical_specializations", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "added_by"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "meeting_users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "daycare_name"
    t.string   "mobile"
    t.string   "token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "message_invite_emails", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "role",       null: false
    t.string   "department", null: false
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "message_invite_emails", ["user_id", "role", "department", "email"], name: "message_invite_emails_index", unique: true, using: :btree
  add_index "message_invite_emails", ["user_id"], name: "index_message_invite_emails_on_user_id", using: :btree

  create_table "message_subjects", force: :cascade do |t|
    t.string   "title"
    t.integer  "parent_subject_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "language"
    t.string   "ref_id"
  end

  add_index "message_subjects", ["parent_subject_id"], name: "index_message_subjects_on_parent_subject_id", using: :btree

  create_table "message_templates", force: :cascade do |t|
    t.integer  "sub_subject_id"
    t.integer  "target_role"
    t.string   "content"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "language"
  end

  add_index "message_templates", ["sub_subject_id"], name: "index_message_templates_on_sub_subject_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "message_template_id"
    t.integer  "owner_id"
    t.string   "title"
    t.string   "content"
    t.datetime "deactivated_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "target_roles",        default: [],              array: true
  end

  add_index "messages", ["message_template_id"], name: "index_messages_on_message_template_id", using: :btree

  create_table "municipals", force: :cascade do |t|
    t.integer  "ref_id"
    t.string   "name"
    t.string   "state"
    t.integer  "municipal_type"
    t.string   "language"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "target_id"
    t.boolean  "archived",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "payment_modes", force: :cascade do |t|
    t.integer  "period"
    t.string   "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_starts", force: :cascade do |t|
    t.integer  "period"
    t.string   "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "member_type"
    t.integer  "sub_type"
    t.integer  "feature"
    t.boolean  "active"
    t.integer  "plan"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "path"
    t.string   "guide_path"
    t.string   "element"
    t.string   "image"
    t.string   "label_key"
    t.integer  "daycare_id",   default: 0
    t.integer  "partner_id",   default: 0
    t.integer  "plan_deposit", default: 0
    t.integer  "order",        default: 0
    t.string   "section",      default: "a"
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.decimal  "price",                 default: 0.0
    t.integer  "allocation",            default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "plan_type"
    t.string   "language"
    t.string   "currency"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
  end

  create_table "poster_email_users", force: :cascade do |t|
    t.string   "email"
    t.string   "locale_poster_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string   "appointment_type"
    t.datetime "datetime"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "token"
    t.string   "email"
  end

  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "sub_task_completes", force: :cascade do |t|
    t.integer  "submitter_id"
    t.integer  "todo_task_complete_id"
    t.integer  "sub_task_id"
    t.datetime "completion_date"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "result",                default: 0
  end

  create_table "sub_tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "todo_task_id"
    t.datetime "deactivated_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "sub_task_type",  default: 0
    t.string   "language"
    t.string   "ref_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "deactivated_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "terms",            default: false
    t.integer  "month"
    t.integer  "discount_code_id"
    t.integer  "transaction_id"
    t.integer  "payment_mode_id"
  end

  create_table "survey_answers", force: :cascade do |t|
    t.integer  "attempt_id"
    t.integer  "question_id"
    t.integer  "option_id"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "survey_attempts", force: :cascade do |t|
    t.integer  "participant_id"
    t.string   "participant_type"
    t.integer  "survey_id"
    t.boolean  "winner"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "remote_id"
    t.decimal  "rate",             precision: 5, scale: 2
  end

  create_table "survey_options", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "weight",         default: 0
    t.string   "text"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deactivated_at"
    t.integer  "remote_id"
  end

  create_table "survey_pending_options", force: :cascade do |t|
    t.integer "user_id"
    t.integer "survey_id"
    t.integer "option_id"
    t.integer "question_id"
    t.integer "subject_id"
    t.boolean "completed"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.integer  "survey_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deactivated_at"
    t.integer  "remote_id"
  end

  create_table "survey_subjects", force: :cascade do |t|
    t.string   "title"
    t.integer  "daycare_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "description"
    t.datetime "deactivated_at"
    t.string   "language"
    t.integer  "remote_id"
  end

  create_table "survey_surveys", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "attempts_number",   default: 0
    t.boolean  "finished",          default: false
    t.boolean  "active",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_subject_id"
    t.integer  "weight",            default: 0
    t.datetime "deactivated_at"
    t.integer  "remote_id"
  end

  create_table "symptoms", force: :cascade do |t|
    t.integer  "illness_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ref_id"
  end

  create_table "todo_completes", force: :cascade do |t|
    t.integer  "submitter_id"
    t.integer  "todo_id"
    t.datetime "completion_date"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0
  end

  create_table "todo_task_completes", force: :cascade do |t|
    t.integer  "submitter_id"
    t.integer  "todo_complete_id"
    t.integer  "todo_task_id"
    t.datetime "completion_date"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "result",           default: 0
  end

  create_table "todo_tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "todo_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "task_type",   default: 0
    t.string   "language"
    t.string   "ref_id"
  end

  create_table "todos", force: :cascade do |t|
    t.string   "title"
    t.integer  "iteration_type",        default: 0
    t.integer  "frequency",             default: 0
    t.integer  "daycare_id"
    t.integer  "user_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "completion_date_type",  default: 0
    t.integer  "completion_date_value", default: 1
    t.string   "language"
    t.string   "ref_id"
    t.integer  "is_active",             default: 1
    t.datetime "start_date"
    t.string   "start_days"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal  "amount",     precision: 8, scale: 2
    t.string   "currency"
    t.string   "card_num"
    t.string   "charge_id"
    t.integer  "user_id"
    t.boolean  "deposit",                            default: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "plan_type",                          default: 0
  end

  create_table "translations", force: :cascade do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.text     "interpolations"
    t.boolean  "is_proc",        default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "user_affiliates", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "affiliate_id"
    t.datetime "deactivated_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_affiliates", ["affiliate_id"], name: "index_user_affiliates_on_affiliate_id", using: :btree
  add_index "user_affiliates", ["user_id"], name: "index_user_affiliates_on_user_id", using: :btree

  create_table "user_daycares", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "daycare_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_occurrences", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "phone_number"
    t.string   "physical_address"
    t.string   "web_address"
    t.string   "about_yourself"
    t.string   "education"
    t.boolean  "online_presence",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "certifications",   default: [],   array: true
  end

  create_table "user_todo_destroys", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "role",                   default: 0
    t.string   "name"
    t.string   "stripe_customer_token"
    t.integer  "department_id"
    t.datetime "trial_end_date"
    t.boolean  "email_confirmed",        default: false
    t.string   "confirm_token"
    t.boolean  "deposit_required",       default: false
    t.string   "card_number"
    t.string   "stripe_customer"
    t.integer  "plan_type"
    t.string   "daycare_name"
    t.string   "mobile"
    t.string   "default_password_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, where: "((email)::text <> ''::text)", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "url"
    t.string   "language"
    t.string   "video_type"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.string   "vote_candidate_code"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "votes", ["vote_candidate_code"], name: "index_votes_on_vote_candidate_code", using: :btree
  add_index "votes", ["voter_id"], name: "index_votes_on_voter_id", using: :btree

  add_foreign_key "schedules", "users"
end
