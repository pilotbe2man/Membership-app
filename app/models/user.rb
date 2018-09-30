# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default("0")
#  name                   :string
#  stripe_customer_token  :string
#  department_id          :integer
#  trial_end_date         :datetime
#  email_confirmed        :boolean          default("false")
#  confirm_token          :string
#  deposit_required       :boolean          default("false")
#  card_number            :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
    include HasMailchimp
    include HasSubscription
    include HasTransaction
    include HasDiscountCode
    include HasTodos
    include HasOccurrences
    include HasTrial
    include HasVotes
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    before_create :confirmation_token

    has_one :user_daycare,                                       dependent: :destroy
    has_one :daycare,                                            through: :user_daycare
    has_many :children,                                          class_name: 'Child', foreign_key: 'parent_id'
    has_many :votes, as: :voter

    has_one :user_affiliate,                                    dependent: :destroy
    has_one :affiliate,                                         through: :user_affiliate

    has_many :messages,                                         foreign_key: 'owner_id'

    has_many :notifications,                                    foreign_key: 'target_id'

    # <--- health conversations-related assocs
    has_many :discussions,                                      through: :discussion_participants

    has_many :discussion_participants,                          as: :participant

    has_many :comments

    has_many :collaborations,                                   class_name: 'ChildCollaborator', as: :collaborator
    # health conversations-related assocs --->

    has_one :user_profile

    belongs_to :department

    has_many :health_records,                                   :as => :recorder

    has_many :message_invite_emails

    validates :department_id,                                   presence: true, :if => :worker?

    validates :name, :email, :role,                             presence: true, :unless => :worker_or_parent?

    # validates :children,                                        presence: true, :if => :parentee?

    validates_uniqueness_of :email, allow_blank: true



    enum role: [:parentee, :worker, :manager, :admin, :partner, :medical_professional]

    accepts_nested_attributes_for :children, :user_daycare, :user_affiliate, :user_profile, allow_destroy: true


    scope :name_like, ->(search) { where("LOWER(users.name) LIKE :search", :search => "%#{search.downcase}%") }
    scope :email_like, ->(search) { where("LOWER(users.email) LIKE :search", :search => "%#{search.downcase}%") }
    scope :daycare_like, ->(search) { joins(:user_daycare).joins('LEFT OUTER JOIN daycares ON user_daycares.daycare_id = daycares.id').where("LOWER(daycares.name) LIKE :search", :search => "%#{search.downcase}%") }
    scope :by_daycare, ->(search) { joins(:user_daycare).where("user_daycares.daycare_id = :search", :search => "#{search}") }
    scope :department_like, ->(search) { joins(:department).where("LOWER(departments.name) LIKE :search", :search => "%#{search.downcase}%") }
    scope :by_role, ->(search) { where("(users.role = :search) OR (:search = -1)", :search => "#{search.blank? ? -1 : search }") }

    # scope :all_daycare_alert_records, ->(query='') {  
    #                                 joins("LEFT JOIN user_daycares ON user_daycares.user_id = users.id")
    #                                 .joins("LEFT JOIN health_records ON health_records.daycare_id = user_daycares.daycare_id")
    #                                 .joins("LEFT JOIN departments ON departments.id = health_records.department_id")
    #                                 .select("health_records.*, departments.department_id, departments.name AS department_name, department_todos.todo_active")
    #                                 .where("todos.title LIKE :search", search: "%#{query}%")
    #                             }


    def newly_signed_up?
      sign_in_count == 1
    end
    
    def email_activate
      self.email_confirmed = true
      self.confirm_token = nil
      save!(:validate => false)
    end

    def is_worker?
        self.affiliate.nil?
    end

    def worker_or_parent?
        self.role == 'parentee' or self.role == 'worker'
    end    

    def is_trial_member?
        days = GlobalSetting.find_by(key: "INITIAL_MEMBER_LIMIT_DAY").value.to_i
        DateTime.now.days_ago(days) <= self.created_at
    end

    def remain_trial_second
        days = GlobalSetting.find_by(key: "INITIAL_MEMBER_LIMIT_DAY").value.to_i
        return days * 24 * 60 * 60 - (Time.now - self.created_at).to_i
    end

private
    def confirmation_token
      if self.confirm_token.blank?
          self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end


  def self.find_first_by_auth_conditions warden_conditions
    conditions = warden_conditions.dup

    if (email = conditions.delete(:email)).present?
      where(email: email.downcase).first
    elsif conditions.has_key?(:reset_password_token)
      where(reset_password_token: conditions[:reset_password_token]).first
    end
  end

  def email_required?
    false
  end    
end
