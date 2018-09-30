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

class Vote < ActiveRecord::Base
  belongs_to :voter, polymorphic: true

  validates :vote_candidate_code, uniqueness: {scope: :voter_id, message: ' can only vote once.'}
end
