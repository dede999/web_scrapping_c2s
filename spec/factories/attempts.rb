FactoryBot.define do
  factory :attempt do
    task_id { "MyString" }
    success { false }
    brand { "MyString" }
    model { "MyString" }
    price { 9.99 }
  end
end
