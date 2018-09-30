class AddVoteRelatedModel < ActiveRecord::Migration
  def change
    create_table(:votes) do |t|
      t.string    :vote_candidate_code
      t.integer   :voter_id
      t.string    :voter_type
      t.timestamps null: false
    end

    add_index :votes, :vote_candidate_code
    add_index :votes, :voter_id
  end
end
