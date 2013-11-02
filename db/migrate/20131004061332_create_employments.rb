class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.string :title
      t.string :company
      t.integer :industry
      t.integer :start_date
      t.integer :end_date

      t.timestamps
    end
  end
end
