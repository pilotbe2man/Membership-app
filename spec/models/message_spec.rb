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

require 'rails_helper'

RSpec.describe Message, type: :model do
end
