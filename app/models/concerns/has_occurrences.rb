module HasOccurrences
    extend ActiveSupport::Concern

    included do
        has_many :user_occurrences,                                 dependent: :destroy
        has_many :active_user_occurrences,                          -> { where(status: 0) }, class_name: 'UserOccurrence'
        has_many :inactive_recurring_todos,                         through: :active_user_occurrences, source: :todo
    end
end