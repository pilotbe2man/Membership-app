require 'rails_helper'

RSpec.describe MessagesHelper, type: :helper do
  let(:current_user) { create(:user) }

  describe '#options_for_message_recipients_select' do
    it 'message recipients' do
      expect(options_for_message_recipients_select).to eq [["Parents", "parentee"], ["Workers", "worker"]]
    end
  end

   describe '#options_for_message_senders_select' do
    it 'message senders' do
      expect(options_for_message_senders_select).to eq [["<span class=\"translation missing\" title=\"translation missing: en.pages.nav bar.admin\">admin</span>s", "admin"], ["<span class=\"translation missing\" title=\"translation missing: en.pages.nav bar.partner\">partner</span>s", "partner"]]
    end
  end

   describe '#options_for_template_localizations' do
    it 'should return options template localizations' do
      expect(options_for_template_localizations).to eq [["English", :en], ["Norwegian", :nk], ["French", :fr]]
    end
  end

  describe '#edit_template_header' do
    it 'template header' do
      expect(edit_template_header).to eq "Edit Message Template :"
    end
  end

  describe '#add_subject_header' do
    it 'subject header' do
      expect(add_subject_header).to eq "Message > Create Subject"
    end
  end

  describe '#add_sub_subject_header' do
    it 'sub subject header' do
      expect(add_sub_subject_header).to eq "Message > Create Subject > Create Sub-Subject"
    end
  end

  describe 'add_recipient_header' do
    it 'recipient header' do
      expect(add_recipient_header).to eq "Message > Create Subject > Create Sub-Subject > Choose Recipient"
    end
  end

  describe '#add_template_content_header' do
    it 'template header' do
      expect(add_template_content_header).to eq "Message > Create Subject > Create Sub-Subject > Choose Recipient > Add Content"
    end
  end

   describe '#choose_department_header' do
    it 'department header' do
      expect(choose_department_header).to eq "Message Options > Choose Department"
    end
  end

   describe '#choose_recipient_header' do
    it 'recipient header' do
      expect(add_recipient_header).to eq "Message > Create Subject > Create Sub-Subject > Choose Recipient"
    end
  end

  describe '#choose_subject_header' do
    it 'subject header' do
      expect(choose_subject_header).to eq "Message Options > Choose Department > Choose Recipient > Choose Subject"
    end
  end

   describe '#choose_sub_subject_header' do
    it 'sub subject header' do
      expect(choose_sub_subject_header).to eq "Message Options > Choose Department > Choose Recipient > Choose Subject > Choose Sub-subject"
    end
  end

  describe '#create_message_from_template_header' do
    it 'message from template header' do
      expect(create_message_from_template_header).to eq "Message Options > Choose Department > .. > Send"
    end
  end

  describe '#progress_bar_step' do
    it 'complete' do
      expect(progress_bar_step('Choose Subject','Choose Recipient')).to eq 'complete'
    end

    it 'active' do
      expect(progress_bar_step('Choose Subject','Choose Subject')).to eq 'active'
    end

    it 'disabled' do
      expect(progress_bar_step('Choose Recipient','Choose Subject')).to eq 'disabled'
    end
  end

  describe '#message_role_label' do
    it 'role label recipient' do
      expect(message_role_label).to eq 'Recipient'
    end

    it 'role label sender' do
      params[:list_type] = 'received' 
      expect(message_role_label).to eq 'Sender'
    end
  end

  describe '#message_role_value' do
    let(:user) { create(:user, name: 'Sam') }
    let(:message) { create(:message, owner: user) }
    it 'role value' do
      params[:list_type] = 'received'
      expect(message_role_value(message)).to eq 'Sam'
    end

    it 'role value' do
      expect(message_role_value(message)).to eq "Worker, Parentee"
    end
  end
end