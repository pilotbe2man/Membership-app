class AddHealthRecordTable < ActiveRecord::Migration
  def change
    create_table :health_records do |t|
      t.string     :protocol_code
      t.references :owner, polymorphic: true
      t.references :recorder, polymorphic: true
      t.datetime   :deactivated_at

      t.timestamps null: false
    end

    create_table :health_record_components do |t|
      t.references :health_record, index: true
      t.string     :code
      t.string     :value
      t.datetime   :deactivate_at

      t.timestamps null: false
    end
  end
end
