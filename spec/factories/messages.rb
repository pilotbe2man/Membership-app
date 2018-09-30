# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  message_template_id :integer
#  owner_id            :integer
#  title               :string
#  content             :string
#  deactivated_at      :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  target_roles        :string           default("{}"), is an Array
#
# Indexes
#
#  index_messages_on_message_template_id  (message_template_id)
#

FactoryGirl.define do
  factory :message do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph(10) }
    target_roles ['worker', 'parentee']

    factory :mngr_message_for_workers do
      target_roles ['worker']

      association :message_template
    end

    factory :mngr_message_for_parents do
      target_roles ['parentee']

      association :message_template
    end

    factory :admin_message_for_workers do
      target_roles ['worker']
    end

    factory :admin_message_for_parents do
      target_roles ['parentee']
    end

    factory :admin_message_for_managers do
      target_roles ['manager']
    end

    association :owner, factory: :user
  end
end
