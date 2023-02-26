require "minitest/test_task"

ENV["PORT"] ||= "3000"
ENV["APP_ENV"] = "test"
ENV["RACK_ENV"] = "test"
Minitest::TestTask.create(:minitest) do |t|
  t.libs << "app"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end
