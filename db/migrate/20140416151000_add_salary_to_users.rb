class AddSalaryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_salary, :integer

    create_table :salaries do |t|
      t.integer :value
      t.integer :user_id

      t.timestamps
      t.datetime :ended_at
    end
  end
end
