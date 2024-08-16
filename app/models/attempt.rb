class Attempt < ApplicationRecord
  validates :task_id, :url, presence: true
  validates :brand, :model, :price, presence: true, if: :success
end
