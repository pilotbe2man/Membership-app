class CreateMedicalSpecializations < ActiveRecord::Migration
  def change
    create_table :medical_specializations do |t|
      t.string   :name
      t.string   :code
      t.integer  :added_by
      t.datetime :deactivated_at

      t.timestamps null: false
    end
  end
end
