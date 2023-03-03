
def load_seed_data
  User.create!(
    email: "pat@example.com",
    payment_method_id: SecureRandom.uuid,
  )

  Product.create!(
    name: "Flux Capacitor",
    quantity_remaining: 100,
    price_cents: 123_00,
  )
  Product.create!(
    name: "Self-sealing Stembolt",
    quantity_remaining: 4,
    price_cents: 5678_00,
  )
  Product.create!(
    name: "Graviton Emitter",
    quantity_remaining: 32,
    price_cents: 765_99,
  )
  Product.create!(
    name: "Thopter Cleaning Fluid",
    quantity_remaining: 1_000,
    price_cents: 12_44,
  )
end

if Rails.env.development?
  load_seed_data
else
  puts "[ db/seeds.rb ] not running in development, so doing nothing"
end
