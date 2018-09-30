# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  attachable_id   :integer
#  attachable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deactivated_at  :datetime
#

FactoryGirl.define do
    factory :attachment do
        file { File.open(File.join(Rails.root, '/lib/dummy_assets/ruby-icon.png')) }
        attachable_type { 'DaycareProfile' }

        factory :icon_attachment do
            association :attachable, factory: :todo
        end

        factory :child_profile_image do
          association :attachable, factory: :child
        end

    end
end
