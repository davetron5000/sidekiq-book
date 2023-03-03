require "net/http"

class WelcomeController < ApplicationController
  def show
    @service_statuses = [
      postgres_status,
      redis_status,
      payments_status,
      fulfillment_status,
      email_status,
    ]
  end

private

  def payments_status    = PaymentsServiceWrapper.new.status
  def fulfillment_status = FulfillmentServiceWrapper.new.status
  def email_status       = EmailServiceWrapper.new.status

    def postgres_status
      service_status = ServiceStatus.new(name: "postgres")
      begin
        Order.count
        service_status.good!(
          ActiveRecord::Base.connection.
          raw_connection.
          conninfo_hash.
          slice(:dbname, :hostaddr, :host, :port, :user)
        )
      rescue => ex
        service_status.problem!(ex)
      end
      service_status
    end

    def redis_status
      service_status = ServiceStatus.new(name: "redis")
      redis = Redis.new(url: ENV["SIDEKIQ_REDIS_URL"])
      begin
        redis.set("diagnostic-time",Time.zone.now)
        redis.get("diagnostic-time")
        service_status.good!(redis.connection.to_h.merge(keys: redis.keys))
      rescue => ex
        service_status.problem!(ex)
      end
      service_status
    end
end
