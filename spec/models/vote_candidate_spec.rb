require 'rails_helper'

RSpec.describe VoteCandidate, type: :model do
  it 'should return name and code' do
    @vote_candidate = VoteCandidate.new
    expect(@vote_candidate.healthier_childcare).to eq :name=>"Healthier Candidate", :code=>"hcc"
  end
end