class BaseServiceWrapper
  def initialize(service_descriptive_name, url)
    @service_descriptive_name = service_descriptive_name
    @url  = url.to_s
  end

  def info
    {
      url: @url
    }
  end

  def status
    uri = URI(@url + "/status")
    service_status = ServiceStatus.new(name: @service_descriptive_name)
    begin
      http_response = Net::HTTP.get_response(
        uri,
        headers,
      )
      http_response.code
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

private

  def headers(content = nil)
    {
      "Accept" => "application/json",
      "Content-Length" => content.to_s.length.to_s,
    }
  end
end
