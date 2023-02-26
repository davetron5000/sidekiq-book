require "sinatra"
require "json"

set :bind, ENV.fetch("BINDING")
set :port, ENV.fetch("PORT")

before do
  accept = request.env["HTTP_ACCEPT"].to_s.split(/,/).map(&:strip).map(&:downcase)

  accepts_json = accept.include?("application/json")
  accepts_anything = accept.include?("*/*")

  if !accepts_json && !accepts_anything
    halt 406
  end

  begin
    @request_payload = if request.env["CONTENT_LENGTH"] == "0"
                         {}
                       else
                         JSON.parse(request.body.read)
                       end
  rescue => ex
    logger.error ex
    halt 422
  end

  if request.env["HTTP_X_BE_SLOW"]
    time = if request.env["HTTP_X_BE_SLOW"] == "true"
             rand(10) + 1
           else
             request.env["HTTP_X_BE_SLOW"].to_i
           end
    logger.info "Sleeping #{time} seconds"
    sleep time
  end

  if request.env["HTTP_X_THROTTLE"] == "true"
    logger.info "Request to throttle"
    halt 429
  end

  if request.env["HTTP_X_CRASH"] == "true"
    logger.info "Request to crash"
    halt [503,504].sample
  end
end

get "/" do
  200
end

get "/payments/status" do
  200
end

$charges = []
post "/payments/charge" do
  if @request_payload["amount_cents"] == 99_99
    response = {
      status: "declined",
      explanation: "Insufficient funds"
    }
    [ 200, [], [ response.to_json ] ]
  else
    if $charges.any? { |charge|
      charge["customer_id"] == @request_payload["customer_id"] &&
        charge["amount_cents"] == @request_payload["amount_cents"]
    }
      response = {
        status: "declined",
        explanation: "Possible fraud",
      }
      [ 200, [], [ response.to_json ] ]
    else
      $charges << @request_payload
      response = {
        status: "success",
        charge_id: "ch_#{SecureRandom.uuid}",
      }
      [ 201, [], [ response.to_json ] ]
    end
  end
end

get "/fulfillment/status" do
  200
end

put "/fulfillment/request" do
  if @request_payload["address"].to_s.strip == ""
    response = {
      status: "rejected",
      error: "Missing address",
    }
    [ 422, [], [ response.to_json ] ]
  else
    response = {
      status: "accepted",
      request_id: SecureRandom.uuid,
    }
    [ 202, [], [ response.to_json ] ]
  end
end

get "/email/status" do
  200
end

post "/email/send" do
  if @request_payload["to"].to_s.strip == ""
    response = {
      status: "not-queued",
      errorMessage: "to required",
    }
    [ 422, [], [ response.to_json ] ]
  elsif @request_payload["template_id"].to_s.strip == ""
    response = {
      status: "not-queued",
      errorMessage: "template_id required",
    }
    [ 422, [], [ response.to_json ] ]
  else
    response = {
      status: "queued",
      email_id: SecureRandom.uuid,
    }
    [ 202, [], [ response.to_json ] ]
  end
end
