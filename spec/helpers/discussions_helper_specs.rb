require 'rails_helper'

RSpec.describe DiscussionsHelper, type: :helper do
  describe '#daycare_logo' do
    let(:daycare){ create(:daycare) }

    it 'should return daycare logo' do
      attachment = create(:attachment, attachable_id: daycare.id)
      expect(daycare_logo(daycare)).to include 's3_domain_url?'
    end

    it 'should return daycare logo' do
      expect(daycare_logo(daycare)).to eq 'childcare-logo-04.png'
    end
  end

  describe '#discussion_owner_avatar' do
    context 'owner parent' do
      let(:user) { create(:parentee_user) }
      let(:discussion){ create(:discussion, owner: user) }
      it 'return parent png' do
        expect(discussion_owner_avatar(discussion)).to eq 'parent.png'        
      end
    end

     context 'owner is a worker or manager' do
      let(:daycare){ create(:daycare) }
      let(:user) { create(:user) }
      let(:discussion){ create(:discussion, owner: user) }
      it 'return manager name' do
        create(:user_daycare, user: user, daycare: daycare)
        attachment = create(:attachment, attachable_id: daycare.id)
        expect(discussion_owner_avatar(discussion)).to include 's3_domain_url?'        
      end
    end

    context 'user is a medical professional' do
      let(:user) { create(:user, role: 'medical_professional') }
      let(:discussion){ create(:discussion, owner: user) }
      it 'return user png' do
        user_profile = create(:user_profile, user: user)
        attachment = create(:attachment, attachable_id: user_profile.id, attachable_type: 'UserProfile')
        expect(discussion_owner_avatar(discussion)).to include 's3_domain_url?'
      end
    end

  end

  describe '#discussion_owner_name' do
    context 'owner parent' do
      let(:user) { create(:parentee_user, name: 'John Snow') }
      let(:discussion){ create(:discussion, owner: user) }
      it 'return parent name' do
        expect(discussion_owner_name(discussion)).to eq 'John Snow'        
      end
    end

     context 'owner is a worker or manager' do
      let(:daycare){ create(:daycare, name: 'Apple') }
      let(:user) { create(:user) }
      let(:discussion){ create(:discussion, owner: user) }
      it 'return manager name' do
        create(:user_daycare, user: user, daycare: daycare)
        expect(discussion_owner_name(discussion)).to eq 'Apple'      
      end
    end

    context 'user is a medical professional' do
      let(:user) { create(:user, role: 'medical_professional', name: 'Tyrion') }
      let(:discussion){ create(:discussion, owner: user) }
      it 'return user name' do
        expect(discussion_owner_name(discussion)).to eq 'Tyrion'
      end
    end
  end

  describe '#discussion_owner' do
    context 'owner is a worker' do
      let(:user) { create(:worker_user) }
      let(:discussion){ create(:discussion, owner: user) }

      it 'should return discussion owner department' do
        expect(discussion_owner(discussion)).to eq discussion.owner.department
      end
    end

    context 'owner is not a worker' do
      let(:user) { create(:user) }
      let(:discussion){ create(:discussion, owner: user) }

      it 'should return discussion owner' do
        expect(discussion_owner(discussion)).to eq discussion.owner
      end
    end
  end

  describe '#allowed_collaborations_reached?' do
    let(:child) { create(:child) }
    it 'should return false' do
      expect(allowed_collaborations_reached?(child)).to eq false
    end

    it 'should return true' do
      create(:child_collaborator, child: child)
      expect(allowed_collaborations_reached?(child)).to eq true
    end
  end

end
