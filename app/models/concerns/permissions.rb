module Permissions
  extend ActiveSupport::Concern

  MESSAGE_PERMISSION_HASH = {
    'admin'   => ['parentee', 'worker', 'manager'],
    'manager' => ['parentee', 'worker'],
    'partner' => ['parentee', 'worker', 'manager']
  }

  included do

    def self.allowed_recipients
      MESSAGE_PERMISSION_HASH.values.flatten.uniq
    end

    def self.allowed_recipients_for_role(role)
      MESSAGE_PERMISSION_HASH[role]
    end

    def self.allowed_senders_for_role(role)
      senders = []
      MESSAGE_PERMISSION_HASH.each_pair do |sender, receivers|
        senders << sender if receivers.include?(role)
      end

      senders
    end

    allowed_recipients.each do |target_role|
      define_method "for_#{target_role}?" do
        target_roles.include?(target_role)
      end
    end

  end

end
