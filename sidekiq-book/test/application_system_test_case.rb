require "test_helper"

Selenium::WebDriver::Chrome::Service.driver_path = "/usr/bin/chromedriver"

# Two things happening in this file:
#
# * Using a headless chrome because no one wants a browser popping up
#   during tests, at least no one that I know :)
# * By default, system tests use rack_test because it's way way faster
#   and generally fine if there is no JavaScript, which there is not much of


Capybara.register_driver :root_headless_chrome do |app|
  options = Selenium::WebDriver::Options.chrome(
    args: [
      "headless",
      "disable-gpu",
      "no-sandbox",
      "disable-dev-shm-usage",
      "whitelisted-ips"
    ],
    logging_prefs: { browser: "ALL" },
  )
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end # register_driver

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :rack_test
end

# Use this as the base class for system tests that require
# JavaScript or that otherwise need a real browser
class BrowserSystemTestCase < ApplicationSystemTestCase
  driven_by :root_headless_chrome, screen_size: [ 1400, 1400 ]
end
