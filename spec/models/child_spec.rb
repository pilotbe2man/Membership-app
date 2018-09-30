require 'rails_helper'

RSpec.describe Child, type: :model do
	it { should have_one(:profile_image).class_name('Attachment') }
	it { should belong_to(:parentee).class_name('User') }
	it { should belong_to(:department) }
	it { should have_many(:discussions) }
	it { should have_many(:collaborators).class_name('ChildCollaborator') }
	it { should have_many(:collaboration_invites) }
	it { should have_many(:pending_collaborations).class_name('CollaborationInvite') }

	it { should validate_presence_of :name }
	it { should validate_presence_of :department_id }
	it { should validate_presence_of :birth_date }
	it { should validate_presence_of :profile_image }
	it { should accept_nested_attributes_for(:profile_image) }

	it { should delegate_method(:daycare).to(:department) }

	it 'should return child age' do
		child = build(:child, birth_date: 'Sat, 26 Jan 2008 00:00:00 UTC +00:00')
		expect(child.age).to eq 9
	end

	it 'should initialize collaborators' do
		child = create(:child)
		child.initialize_collaborators
		expect(child.collaborators.find_by(child_id: child.id, collaborator_type: 'Department')).not_to eq nil
		expect(child.collaborators.find_by(child_id: child.id, collaborator_type: 'User')).not_to eq nil
	end
end