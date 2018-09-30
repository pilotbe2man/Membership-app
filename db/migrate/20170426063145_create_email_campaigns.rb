class CreateEmailCampaigns < ActiveRecord::Migration
  def change
    create_table :email_campaigns do |t|
      t.string :subject
      t.string :content
      t.string :language

      t.timestamps null: false
    end
  end
end
