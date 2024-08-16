class Attempt < ApplicationRecord
  validates :task_id, presence: true
  validates :brand, :model, :price, presence: true, if: :success
end
