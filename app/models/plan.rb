# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  name       :string
#  
#  plan_type: 1: Daily amount
#             2: Phase 1 Deposit
#             3: Phase 2 Deposit
#             4: Phase 3 Deposit
#

class Plan < ActiveRecord::Base
    has_attached_file :document, path: "plans/:id_partition/:filename"

    #validates attachment of files
    validates_attachment_content_type :document, content_type: /./

    has_many :subscriptions
    has_many :users,                                      through: :subscriptions
    belongs_to :payment_mode

    validates :plan_type, :price, :language,                   presence: true

    default_scope { order(allocation: :asc) }

    scope :by_language,     ->(search) { where("(LOWER(plans.language) LIKE :search)", :search => "%#{search.downcase}%") }
    scope :by_currency,     ->(search) { where("(LOWER(plans.currency) LIKE :search)", :search => "%#{search.downcase}%") }
end
