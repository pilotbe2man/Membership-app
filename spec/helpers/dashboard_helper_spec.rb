require 'rails_helper'

RSpec.describe DashboardHelper, type: :helper do

  describe '#notif_sender_avatar' do
    it 'should return admin avatar' do
      user = create(:admin_user)
      message = create(:message, owner: user)
      notification =  create(:message_notification, source: message)
      expect(notif_sender_avatar(notification)).to eq 'super-admin.png'
    end

     it 'should return manager avatar' do
      notification =  create(:message_notification)
      expect(notif_sender_avatar(notification)).to eq 'manager.png'
    end

    # it 'should return partner avatar' do
    #   user = create(:user, role: 'partner')
    #   message = create(:message, owner: user)
    #   notification =  create(:message_notification, source: message)
    #   affiliate = create(:affiliate, partner: user)
    #   expect(notif_sender_avatar(notification)).to eq 'super-admin.png'
    # end

    it 'should return parentee avatar' do
      user = create(:parentee_user)
      message = create(:message, owner: user)
      notification =  create(:message_notification, source: message)
      expect(notif_sender_avatar(notification)).to eq 'parent.png'
    end

    context 'user is a worker' do
      let(:user){create(:worker_user)}
      it 'return worker avatar' do
        message = create(:message, owner: user)
        notification =  create(:message_notification, source: message)
        expect(notif_sender_avatar(notification)).to eq 'worker.png'
      end

      # Check for when source king is not message
      # it 'return worker avatar' do
      #   # message = create(:message, owner: user)
      #   notification =  create(:message_notification)
      #   expect(notif_sender_avatar(notification)).to eq 'worker.png'
      # end
    end

    it  'should return logo png' do
      user = create(:user, role: 'medical_professional')
      message = create(:message, owner: user)
      notification =  create(:message_notification, source: message)
      expect(notif_sender_avatar(notification)).to eq 'logo_menu.png'
    end
  end

  describe '#notif_sender_name' do
    it 'should return source owner name' do
      user = create(:user, name: 'John hill')
      message = create(:message, owner: user)
      notification =  create(:message_notification, source: message)
      expect(notif_sender_name(notification)).to eq 'John hill'
    end

    #Test for discussion and comment
  end

  describe '#discussion_notif_link' do
    let(:current_user){ create(:user) }

  #   it 'should return link for parentee_user' do
  #     # current_user = create(:parentee_user)
  #     message = create(:message, owner: current_user)
  #     subject = create(:subject, source: message)

  #     notification = create(:message_notificatio, source: message)
  #     expect(discussion_notif_link(notification)).to eq ''
  #   end

    it 'should return #' do
      notification =  create(:message_notification)
      expect(discussion_notif_link(notification)).to eq '#'
    end
  end
end