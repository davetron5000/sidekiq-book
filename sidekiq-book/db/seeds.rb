require "factory_bot"

def load_seed_data
  FactoryBot.create(:user, email: "pat@example.com")

  FactoryBot.create(:product, name: "Flux Capacitor", quantity_remaining: 100, price_cents: 123_00)
  FactoryBot.create(:product, name: "Self-sealing Stembolt", quantity_remaining: 4, price_cents: 5678_00)
  FactoryBot.create(:product, name: "Graviton Emitter", quantity_remaining: 32, price_cents: 765_99)
  FactoryBot.create(:product, name: "Thopter Cleaning Fluid", quantity_remaining: 1_000, price_cents: 12_44)
end

if Rails.env.development?
  load_seed_data
else
  puts "[ db/seeds.rb ] not running in development, so doing nothing"
end
