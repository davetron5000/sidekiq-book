class EmailServiceWrapper < BaseServiceWrapper
  def initialize
    super("email", ENV.fetch("EMAIL_API_URL"))
  end

  def send_email(to_email, template_id, template_data)
    uri = URI(@url + "/send")
    body = {
      to: to_email,
      template_id: template_id,
      template_data: template_data,
    }
    http_response = request(:post, uri, body)
    if http_response.code == "202"
      response = JSON.parse(http_response.body)
      Result.new(response["email_id"])
    else
      raise_error!(http_response)
    end
  end

  class Result
    attr_reader :email_id
    def initialize(email_id)
      @email_id = email_id
    end
    def success? = true
  end

end
