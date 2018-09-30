require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#create_admin_breadcrumbs' do
    it 'return admin breadcrumbs' do
      expect(create_admin_breadcrumbs).to eq [{:title=>"Healthier Childcare", :url=>"/admin"}]
    end
  end

  describe '#breadcrumb_add' do
    it 'add breadcrumb' do
      expect(breadcrumb_add('Subjects',admin_subjects_path)).to eq [{:title=>"Healthier Childcare", :url=>"/admin"}, {:title=>"Subjects", :url=>"/admin/subjects"}]
    end
  end

  describe '#render_breadcrumbs' do
    it 'admin breadcrumb' do
      expect(render_breadcrumbs(0)).to eq "<ol id=\"breadcrumbs\">\n    <li>\n      <a href=\"/admin\">Healthier Childcare</a>\n    </li>\n  <li class=\"current\">\n    \n  </li>\n</ol>"
    end
  end

  describe '#active_controller?' do
    it 'test active controller' do
      data = {}
      data[:controller] = 'Controller'
      data[:actiom] = nil
      params[:controller] = data[:controller]
      expect(active_controller?(data)).to eq 'current'
    end
  end

  describe '#yield_js_translations' do
    it 'js translation' do
      expect(yield_js_translations.to_s).to eq "{\"featured_daycare\"=>\"Childcare has enrolled into the Healthier and Safer Childcare accreditation Program to better safeguard the children and my daycare staff from potential harm and suffering associated with preventable infectious diseases.\", \"featured_daycare_by_plan\"=>\"Daycare has Reserved their spot on the accreditation program by making a deposit of 100 kr.\", \"no_template_for_role\"=>\"No message template found.\", \"invalid_template_file\"=>\"Invalid file! Please upload text file only.\", \"required_filter_role\"=>\"Please choose filter Role.\", \"required_filter_subject\"=>\"Please choose filter Subject.\", \"required_filter_sub_subject\"=>\"Please choose filter Sub-subject.\", \"required_dept_filter\"=>\"Please choose a department\", \"required_child_filter\"=>\"Please choose a child\", \"worker_progress_chart_title\"=>\"Infection Risk Assessment\"}"
    end
  end

  describe '#current_user_role_avatar' do
    context 'user is an admin' do
      let(:current_user) { create(:admin_user) }
      it 'should return admin avatar' do
        expect(current_user_role_avatar).to eq 'super-admin.png'
      end
    end

    context 'user is a manager' do
      let(:current_user) { create(:user) }
       it 'should return manager avatar' do
        expect(current_user_role_avatar).to eq 'manager-md.png'
      end
    end

    context 'description' do
      let(:current_user) { create(:user, role: 'partner') }
      it 'should return partner avatar' do
        expect(current_user_role_avatar).to eq 'partner-md.png'
      end      
    end

    context 'user is a parent' do
      let(:current_user) { create(:parentee_user) }
      it 'should return parentee avatar' do
        expect(current_user_role_avatar).to eq 'parent-md.png'
      end
    end

    context 'user is a worker' do
      let(:current_user) { create(:worker_user) }
      it 'return worker avatar' do
        expect(current_user_role_avatar).to eq 'worker-md.png'
      end
    end

    context 'user is a medical professional' do
      let(:current_user) { create(:user, role: 'medical_professional') }
      it  'should return logo png' do
        user_profile = create(:user_profile, user: current_user)
        attachment = create(:attachment, attachable_id: user_profile.id, attachable_type: 'UserProfile')
        expect(current_user_role_avatar).to include 's3_domain_url?'
      end
    end

    # context 'other role' do
    #   let(:current_user) { create(:user, role: none) }
    #   it  'should return logo png' do
    #     expect(current_user_role_avatar).to eq 'logo_menu.png'
    #   end
    # end
  end

  describe '#pretty_long_date' do
    it 'long date' do
      expect(pretty_long_date(Date.parse('23-07-2017'))).to eq "23/07/2017 @ 12:00:00 AM"
    end
  end

   describe '#pretty_short_date' do
    it 'long date' do
      expect(pretty_short_date(Date.parse('23-07-2017'))).to eq "23/07/2017"
    end
  end

  describe '#get_active_link' do
    it 'return active action link' do
      expect(get_active_link('index')).to eq nil
    end
  end

  describe '#get_video_link' do
    it 'returns video link' do
      video = Video.create(category: 'Health', video_type: 'youtube', language: 'ENGLISH', url: 'https://www.youtube.com/watch?v=DWL67xOeQ-E')
      expect(get_video_link('Health','youtube','English')).to eq "https://www.youtube.com/watch?v=DWL67xOeQ-E"
    end
  end
end