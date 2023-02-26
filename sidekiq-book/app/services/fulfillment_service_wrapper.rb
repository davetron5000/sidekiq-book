class FulfillmentServiceWrapper < BaseServiceWrapper
  def initialize
    super("order fulfillment", ENV.fetch("FULLFILLMENT_API_URL"))
  end
end
