FactoryBot.define do
  factory :product do
    name { Faker::Device.unique.model_name }
    price_cents { rand(10000) + 100_00 } # must not be 99_99
    quantity_remaining { rand(10) + 1 }
  end
  trait :priced_for_decline do
    price_cents { 99_99 }
  end
  trait :not_available do
    quantity_remaining { 0 }
  end
end

