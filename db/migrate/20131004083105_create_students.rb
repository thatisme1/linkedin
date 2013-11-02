class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :inst_name
      t.integer :start_date
      t.integer :end_date
      t.text :description
      t.integer :user_id
      t.timestamps
    end
  end
end
