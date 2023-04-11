FactoryBot.define do
  factory :user do
    # This ensures only one user is created because
    # ApplicationController just grabs the first user. This is
    # because I didn't want to add real auth to this app
    initialize_with { User.first || User.create!(email: email, payment_method_id: payment_method_id) }
    email { Faker::Internet.unique.safe_email }
    payment_method_id { SecureRandom.uuid }
  end
end

