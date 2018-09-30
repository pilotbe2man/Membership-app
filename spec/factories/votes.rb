# == Schema Information
#
# Table name: votes
#
#  id                  :integer          not null, primary key
#  vote_candidate_code :string
#  voter_id            :integer
#  voter_type          :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_votes_on_vote_candidate_code  (vote_candidate_code)
#  index_votes_on_voter_id             (voter_id)
#

FactoryGirl.define do
  factory :vote do
    vote_candidate_code { 'hcc' }

    association :voter, factory: :user
  end
end