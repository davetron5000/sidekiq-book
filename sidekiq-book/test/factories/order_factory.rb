FactoryBot.define do
  factory :order do
    product
    user
    quantity { 1 }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
  end
end

