require "application_system_test_case"

class WelcomePageTest < ApplicationSystemTestCase
  test "shows service status" do

    visit "/"

    within "[data-testid='service-postgres']" do
      assert_text "✅"
      uri = URI(ENV["DATABASE_URL"])
      assert_text uri.host
      assert_text uri.port
    end
    within "[data-testid='service-redis']" do
      assert_text "✅"
      assert_text ENV["REDIS_URL"]
    end

  end
end
