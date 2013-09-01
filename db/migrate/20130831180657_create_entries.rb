class CreateEntries < ActiveRecord::Migration
  def up
    create_table :entries do |t|
      t.string :original_id
      t.integer :original_minutes
      t.integer :minutes
      t.text :description

      t.string :user

      t.date :date
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end

  def down
    drop_table :entries
  end
end
