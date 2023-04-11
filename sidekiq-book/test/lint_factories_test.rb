require "test_helper"

class LintFactoriesTest < ActiveSupport::TestCase
  test "possible to create factories" do
    FactoryBot.lint(:traits => true)
  end
end
