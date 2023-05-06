FactoryBot.define do
  factory :user do
    # This ensures only one user is created because
    # ApplicationController just grabs the first user. This is
    # because I didn't want to add real auth to this app
    initialize_with {
      User.first || User.create!(email: email,
                                 payments_customer_id: payments_customer_id,
                                 payments_payment_method_id: payments_payment_method_id)
    }
    email { Faker::Internet.unique.email }
    payments_customer_id { "cust_#{SecureRandom.hex(8)}" }
    payments_payment_method_id { "pm_#{SecureRandom.hex(8)}" }
  end
end

