module HasVotes
  extend ActiveSupport::Concern

  included do

    def voted_for? candidate_code
      votes.detect{|_vote| _vote.vote_candidate_code == candidate_code}
    end

  end

end
