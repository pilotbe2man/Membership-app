require 'rails_helper'

RSpec.describe CollaborationInvite do
  let(:invite) { CollaborationInvite.new }

  it { should belong_to(:child) }
  it { should belong_to(:inviter).class_name('User') }

  it { should validate_presence_of(:child_id) }
  it { should validate_presence_of(:inviter_id) }
  it { should validate_presence_of(:invitee_email) }

  it 'should generate invite code' do
    inv_code = invite.generate_invite_code
    expect( /([A-Z])\w{9}/ =~ inv_code ).to eq 0
  end

  it 'should assign an invite code' do
    invite.assign_invite_code
    expect(invite.invite_code =~ /([A-Z])\w{9}/ ).to eq 0
  end

  it 'should update the status attribute' do
    invite.accept!
    expect(invite.status).to eq 'accepted'
  end
end
