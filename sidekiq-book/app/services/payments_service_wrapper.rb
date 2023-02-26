class PaymentsServiceWrapper < BaseServiceWrapper
  def initialize
    super("payments", ENV.fetch("PAYMENTS_API_URL"))
  end
end
