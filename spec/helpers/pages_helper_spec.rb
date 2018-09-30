require 'rails_helper'

RSpec.describe PagesHelper, type: :helper do
  describe '#vote_question' do
    context 'When current user is a manager, worker or parentee' do
      let(:current_user){ create(:user) }

      it 'should return empty string' do
        expect(vote_question).to eq "translation missing: en.votes.manager.question"
      end
    end

    context 'When current user is not a manager, worker or parentee' do
      let(:current_user){ create(:admin_user) }

      it 'should return empty string' do
        expect(vote_question).to eq ''
      end
    end
  end

  describe '#vote_invitation' do
    context 'current user is a manager' do
      let(:current_user){ create(:user) }

      it 'should return votes manager invitation and demand' do
        expect(vote_invitation).to eq "<p>Want to keep the children and staff under your care from harm&#39;s way and fullfil your ethical and professional obligation? Join us to eliminate the factors that spread ongoing infections and absenteeism which can drain your childcare facility&#39;s productivity.</p><p>CONTRIBUTE TO THE HEALTH AND HAPPINESS OF CHILDREN AND EMPLOYEES UNDER YOUR CARE AND SUPERVISION TODAY.</p>"
      end
    end

    context 'current user is a worker or a parentee' do
      let(:current_user){ create(:worker_user) }

      #Have to add test for when vote present
      context 'has not voted for hcc' do
        # let(:vote){ build(:vote, voter: current_user) }

        it 'should return votes current user invitation and demand' do
          expect(vote_invitation).to eq "<p>The risk of infection in a childcare facility does not spare the workers. Studies had proven that a large proportion of daycare staff is women in their childbearing age. During their gestation period, their body&#39;s immune system undergoes several changes that results to a weak immune system. This increases the chances of getting infection both to the mothers and children.</p><p>DEMAND BETTER PROTECTION AGAINST THE ON-GOING RISK OF INFECTION THAT CAN PUT YOUR HEALTH AT RISK. VOTE FOR HEALTH PRESERVING CARE PROGRAM TODAY.</p><span>Vote for Health Preserving Care Program.</span><a href=\"/cast_vote?vote_candidate_code=hcc\" class=\"btn btn-success\" id=\"vote-btn\">Vote</a>"
        end
      end

    end
  end

  # describe '#vote_results' do
  #   let(:current_user){ create(:user) }

  #   it 'vote results parentee' do
  #     expect(vote_results('parentee')).to eq ''
  #   end
  # end

  # describe '#vote_invitation' do
  #   context 'manager' do
  #     let(:current_user){ create(:user) }
  #     it 'return vote invitation' do
  #       expect(vote_invitation).to eq '<p>Want to keep the children and staff under your care from harm&#39;s way and fullfil your ethical and professional obligation? Join us to eliminate the factors that spread ongoing infections and absenteeism which can drain your childcare facility&#39;s productivity.</p><p>CONTRIBUTE TO THE HEALTH AND HAPPINESS OF CHILDREN AND EMPLOYEES UNDER YOUR CARE AND SUPERVISION TODAY.</p>'
  #     end
  #   end

  #   context 'worker' do
  #     let(:current_user){ create(:worker_user) }
  #     it 'return vote invitation' do
  #       expect(vote_invitation).to eq "<p>The risk of infection in a childcare facility does not spare the workers. Studies had proven that a large proportion of daycare staff is women in their childbearing age. During their gestation period, their body&#39;s immune system undergoes several changes that results to a weak immune system. This increases the chances of getting infection both to the mothers and children.</p><p>DEMAND BETTER PROTECTION AGAINST THE ON-GOING RISK OF INFECTION THAT CAN PUT YOUR HEALTH AT RISK. VOTE FOR HEALTH PRESERVING CARE PROGRAM TODAY.</p><span>Vote for Health Preserving Care Program.</span><a href=\"/cast_vote?vote_candidate_code=hcc\" class=\"btn btn-success\" id=\"vote-btn\">Vote</a>"
  #     end
  #   end

  #   context 'worker' do
  #     let(:current_user){ create(:worker_user) }
  #     it 'return vote invitation' do
  #       expect(vote_invitation).to eq "<p>The risk of infection in a childcare facility does not spare the workers. Studies had proven that a large proportion of daycare staff is women in their childbearing age. During their gestation period, their body&#39;s immune system undergoes several changes that results to a weak immune system. This increases the chances of getting infection both to the mothers and children.</p><p>DEMAND BETTER PROTECTION AGAINST THE ON-GOING RISK OF INFECTION THAT CAN PUT YOUR HEALTH AT RISK. VOTE FOR HEALTH PRESERVING CARE PROGRAM TODAY.</p><span>Vote for Health Preserving Care Program.</span><a href=\"/cast_vote?vote_candidate_code=hcc\" class=\"btn btn-success\" id=\"vote-btn\">Vote</a>"
  #     end
  #   end

  # end

  describe '#country_name_from_code' do
    it 'should return english' do
      expect(country_name_from_code('en')).to eq 'English'
    end

     it 'should return country name' do
      expect(country_name_from_code('AU')).to eq 'AUSTRALIA'
    end
  end

end