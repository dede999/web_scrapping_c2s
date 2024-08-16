class AddUrlToAttempts < ActiveRecord::Migration[6.1]
  def change
    add_column :attempts, :url, :string
  end
end
