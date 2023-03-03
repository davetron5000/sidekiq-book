require "net/http"
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

  class HTTPError < StandardError
    attr_reader :code
    def initialize(code, body)
      super("#{code}: #{body}")
      @code = code
    end
  end
  class ClientError < HTTPError
  end
  class ServerError < HTTPError
  end

  def raise_error!(http_response)
    if http_response.code[0] == "4"
      raise ClientError.new(http_response.code,http_response.body)
    elsif http_response.code[0] == "4"
      raise ServerError.new(http_response.code,http_response.body)
    else
      raise HTTPError.new(http_response.code,http_response.body)
    end
  end

  CLASSES = {
    post: Net::HTTP::Post,
    put: Net::HTTP::Put,
  }
  def request(method,uri,body)
    body = body.to_json
    request = CLASSES.fetch(method).new(uri.path,headers(body))
    request.body = body
    Net::HTTP.new(uri.hostname,uri.port).start { |http|
      http.request(request)
    }
  end
end
