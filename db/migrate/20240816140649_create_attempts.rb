class CreateAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :attempts do |t|
      t.string :task_id
      t.boolean :success
      t.string :brand
      t.string :model
      t.decimal :price

      t.timestamps
    end
  end
end
