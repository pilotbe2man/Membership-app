class CreatePosterEmailUsers < ActiveRecord::Migration
  def change
    create_table :poster_email_users do |t|
      t.string :email
      t.string :locale_poster_id

      t.timestamps null: false
    end
  end
end
