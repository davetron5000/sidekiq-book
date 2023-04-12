class EmailServiceWrapper < BaseServiceWrapper
  def initialize
    super("email", ENV.fetch("EMAIL_API_URL"))
  end

  def emoji = Emoji.new(char: "📨",description: "Inbox with incoming envelope")

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

  def search_emails(email, template_id)
    uri = URI(@url + "/emails")
    params = { email: email, template_id: template_id }
    uri.query = URI.encode_www_form(params)
    http_response = @net_http.get_response(uri,headers)
    if http_response.code == "200"
      JSON.parse(http_response.body).map { |email|
        ParsedEmail.new(
          to: email["to"],
          template_id: email["template_id"],
          email_id: email["email_id"],
          template_data: email["template_data"],
        )
      }
    else
      raise_error!(http_response)
    end
  end

  def clear!
    uri = URI(@url + "/emails")
    http_response = request(:delete, uri, "")
    if http_response.code != "200"
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

  class ParsedEmail
    attr_reader :to, :template_id, :email_id, :template_data
    def initialize(to:, template_id:, email_id:, template_data:)
      @to            = to
      @template_id   = template_id
      @email_id      = email_id
      @template_data = template_data
    end
  end

end
