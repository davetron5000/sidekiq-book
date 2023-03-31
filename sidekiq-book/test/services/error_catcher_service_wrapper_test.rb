require "test_helper"

class ErrorCatcherServiceWrapperTest < ActiveSupport::TestCase
  setup do
    ErrorCatcherServiceWrapper.reset_ignored_errors!
  end

  test "reports non-ignored error" do
    mock_net_http = MiniTest::Mock.new

    mock_net_http_instance = MiniTest::Mock.new
    mock_net_http.expect(:new, mock_net_http_instance,[ "fake-api-server", 4000 ])
    response = OpenStruct.new(body: "{}", code: "202")
    mock_net_http_instance.expect(:start, response)

    error_catcher = ErrorCatcherServiceWrapper.new(net_http: mock_net_http)

    result = error_catcher.notify(StandardError.new("OH NOES"))

    mock_net_http.verify
    mock_net_http_instance.verify
    refute result.ignored?
  end

  test "reports message as a string" do
    mock_net_http = MiniTest::Mock.new

    mock_net_http_instance = MiniTest::Mock.new
    mock_net_http.expect(:new, mock_net_http_instance,[ "fake-api-server", 4000 ])
    response = OpenStruct.new(body: "{}", code: "202")
    mock_net_http_instance.expect(:start, response)

    error_catcher = ErrorCatcherServiceWrapper.new(net_http: mock_net_http)

    result = error_catcher.notify("OH NOES")

    mock_net_http.verify
    mock_net_http_instance.verify
    refute result.ignored?
  end

  test "ignores configured error" do
    ErrorCatcherServiceWrapper.ignored_errors << ArgumentError
    mock_net_http = MiniTest::Mock.new


    error_catcher = ErrorCatcherServiceWrapper.new(net_http: mock_net_http)

    result = error_catcher.notify(ArgumentError.new("OH NOES"))

    mock_net_http.verify
    assert result.ignored?
  end
end
