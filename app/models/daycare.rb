# == Schema Information
#
# Table name: daycares
#
#  id               :integer          not null, primary key
#  name             :string
#  address_line1    :string
#  postcode         :string
#  country          :string
#  telephone        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  url              :string
#  num_children     :integer
#  num_worker       :integer
#  care_type        :integer
#  discount_code_id :integer          default("0")
#  payment_month    :integer          default("0")
#  payment_mode_id  :integer
#  payment_start_id :integer
#

class Daycare < ActiveRecord::Base    
    before_destroy :destroy_others

    belongs_to :discount_code
    belongs_to :payment_mode
    belongs_to :payment_start
    belongs_to :municipal

    has_many :departments,                              dependent: :destroy
    has_many :children,                                 through: :departments
    has_many :user_daycares
    has_many :users,                                    through: :user_daycares
    has_many :todo_destroys,                            through: :users
    has_many :parents,                                  -> { (where(role: 0)) }, through: :user_daycares, source: :user
    has_many :workers,                                  -> { (where(role: 1)) }, through: :user_daycares, source: :user
    has_many :managers,                                 -> { (where(role: 2)) }, through: :user_daycares, source: :user

    has_many :survey_subjects
    has_many :surveys,                                  through: :survey_subjects

    has_many :health_records

    # Dashboard relations
    has_many :local_todos,                              -> { includes(:icon).where(language: I18n.locale) }, class_name: 'Todo'

    # Reporting relations
    has_many :local_completed_todos,                    -> { complete }, class_name: 'Todo'
    has_many :local_incomplete_todos,                   -> { incomplete }, class_name: 'Todo'
    has_many :local_available_todos,                    -> { available }, class_name: 'Todo'

    # Dashboard relations
    has_many :global_todos,                             -> { includes(:icon).where(language: I18n.locale) }, through: :departments, source: :todos

    # Reporting relations
    has_many :global_completed_todos,                   -> { complete }, through: :departments, source: :todos
    has_many :global_incomplete_todos,                  -> { incomplete }, through: :departments, source: :todos
    has_many :global_available_todos,                   -> { available }, through: :departments, source: :todos

    # <------- Health conversations
    has_many :discussion_participants,                  as: :participant

    has_many :discussions,                              through: :discussion_participants
    # Health conversations ------->

    has_one :profile_image,                             -> { where(attachable_type: 'DaycareProfile') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy

    validates :name, :address_line1, :postcode, :country, :telephone,              presence: true

    validates :departments,                             presence: true

    scope :search,                                      ->(query, page, per_page_count, limit_count) { where("name LIKE :search", search: "%#{query}%").limit(limit_count).page(page).per(per_page_count) }
    scope :search_by_type,                              ->(query, type, page, per_page_count, limit_count) { where("name LIKE :search and care_type = :type", search: "%#{query}%", type: type).limit(limit_count).page(page).per(per_page_count) }

    scope :name_like, ->(search) { where("LOWER(daycares.name) LIKE :search", :search => "%#{search.downcase}%") }
    scope :address_like, ->(search) { where("LOWER(daycares.address_line1) LIKE :search", :search => "%#{search.downcase}%") }
    scope :by_country, ->(search) { where("LOWER(daycares.country) = :search", :search => "#{search.downcase}") }

    accepts_nested_attributes_for :departments, :user_daycares, :profile_image, allow_destroy: true

    # => Checks if the daycare contains a manager user with an active subscription or trial
    #
    def active_subscription?
      managers.map(&:subscribed?).include?(true) || managers.map(&:active_trial?).include?(true) ? true : false
    end

    # => Checks if the daycare contains a manager user with an active subscription
    #
    def subscribed?
      managers.map(&:subscribed?).include?(true) ? true : false
    end
    # => Lists all complete todos
    #
    def all_completed_todos
        (global_completed_todos + local_completed_todos).uniq
    end

    # => Lists all incomplete todos
    #
    def all_incomplete_todos
        (global_incomplete_todos + local_incomplete_todos).uniq
    end

    # => Lists all available todos
    #
    def all_available_todos
        (global_available_todos + local_available_todos).uniq
    end

    # => Lists all todos within a daycare, both global and local
    #
    def all_todos
        (global_todos.where(language: I18n.locale).to_a.delete_if{ |gt| local_todos.map(&:title).include?(gt.title) } + local_todos)
    end

    def destroy_others
        self.todo_destroys.where(id: self.todo_destroys.ids).delete_all
        self.users.where(id: self.users.ids).delete_all
        self.user_daycares.delete_all
        self.children.where(id: self.children.ids).delete_all
        self.departments.delete_all
        self.surveys.where(id: self.surveys.ids).delete_all
        self.survey_subjects.delete_all
        self.health_records.delete_all
        self.local_todos.delete_all
        self.discussions.where(id: self.discussions.ids).delete_all
        self.discussion_participants.delete_all     
    end

    def department_options
        options = []
        self.departments.each do |dept|
            puts dept.id
            options << [dept.name, dept.id]
        end
        return options
    end

    def care_type_text
        case care_type
        when 1
            I18n.t('register.caretype.ind')
        when 2
            I18n.t('register.caretype.fra')
        when 3
            I18n.t('register.caretype.gov')
        else
            ""
        end
    end
end
