class ErrorCatcherServiceWrapper < BaseServiceWrapper
  def initialize
    super("error-catcher", ENV.fetch("ERROR_CATCHER_API_URL"))
  end

  def emoji = Emoji.new(char: "🐛",description: "caterpillar")
  def status
    uri = URI(@url + "/status")
    service_status = ServiceStatus.new(
      name: @service_descriptive_name,
      emoji: emoji,
    )
    begin
      http_response = Net::HTTP.get_response(
        uri,
        clean_headers,
      )
      if http_response.code == "200"
        service_status.good!(self.info)
      else
        service_status.problem!("Got response #{http_response.code} instead of 200")
      end
    rescue => ex
      service_status.problem!(ex)
    end
    service_status
  end

  def notify(exception)
    uri = URI(@url + "/notification")
    body = {
      exception_class: exception.class,
      exception_message: exception.message,
    }
    http_response = request(:put, uri, body)
    if http_response.code == "202"
      response = JSON.parse(http_response.body)
      Success.new(response["notification_id"])
    else
      raise_error!(http_response)
    end
  end

  def clear!
    uri = URI(@url + "/notifications")
    http_response = request(:delete, uri, "")
    if http_response.code != "200"
      raise_error!(http_response)
    end
  end

  def info
    super.merge({ view: "http://localhost:3001/error-catcher/notifications" })
  end

private

  class Success
    attr_reader :notification_id
    def initialize(notification_id)
      @notification_id = notification_id
    end
    def success? = true
  end
end
