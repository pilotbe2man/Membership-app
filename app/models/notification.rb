# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  source_id   :integer
#  source_type :string
#  target_id   :integer
#  archived    :boolean          default("false")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# can be used for Message, Todo, Discussion, Comment notifications
class Notification < ActiveRecord::Base
  include Deactivatable

  belongs_to :source, polymorphic: true
  belongs_to :target, class_name: 'User'

  #default_scope {order('created_at DESC')}
  scope :unread, -> {where(archived: false)}
  scope :by_source_type, ->(source_type) {where(source_type: source_type)}

  scope :count_by_owner, ->(target_id) { 
                                        joins("LEFT JOIN messages ON messages.id = notifications.source_id")
                                        .where(notifications: {target_id: target_id})
                                        .unread
                                        .group("messages.owner_id")
                                        .select("count(messages.owner_id) as count_message, messages.owner_id as owner_id")
  }

  delegate :owner, to: :source, prefix: true

  def archived!
    self.archived = true
    self.save!
  end

end
