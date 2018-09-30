class CreateIllness < ActiveRecord::Migration
  def change
    create_table :illnesses do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end

    create_table :symptoms do |t|
      t.references :illness
      t.string     :code
      t.string     :name

      t.timestamps null: false
    end
  end
end
