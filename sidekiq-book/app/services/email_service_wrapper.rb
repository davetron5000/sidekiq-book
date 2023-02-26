class EmailServiceWrapper < BaseServiceWrapper
  def initialize
    super("email", ENV.fetch("EMAIL_API_URL"))
  end
end
