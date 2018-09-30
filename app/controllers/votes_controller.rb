class VotesController < ApplicationController
  before_action :authenticate_user!

  def cast_vote
    current_user.votes.create(vote_params)

    redirect_to :back
  end

  private

  def vote_params
    params.permit(:vote_candidate_code)
  end

end
