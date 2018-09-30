class AddContentToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :content, :string
  end
end
