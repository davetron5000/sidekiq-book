class ServiceStatus
  include ActiveModel::Model

  attr_accessor :name, :emoji, :status, :info, :type, :throttle, :crash, :sleep

  def good!(info)
    self.status = true
    self.info = info
  end

  def problem!(problem_or_exception)
    self.status = problem_or_exception
    self.info = {}
  end

  def self.all
    [
      postgres_status,
      redis_status,
      error_catcher_status,
    ] + api_services
  end

  def self.api_services
    [
      payments_status,
      fulfillment_status,
      email_status,
    ]
  end

  def self.find(name)
    service_status = self.all.detect { |service_status|
      service_status.name == name
    }
    if service_status.nil?
      raise ActiveRecord::RecordNotFound("No service '#{name}'")
    end
    service_status
  end

  def update(params)
    BaseServiceWrapper.update_config(self.name, params.stringify_keys)
  end

  def api? = self.type.to_s == "api"

private


  def self.payments_status      = PaymentsServiceWrapper.new.status
  def self.fulfillment_status   = FulfillmentServiceWrapper.new.status
  def self.email_status         = EmailServiceWrapper.new.status
  def self.error_catcher_status = ErrorCatcherServiceWrapper.new.status

  def self.postgres_status
    service_status = ServiceStatus.new(name: "postgres", type: :db)
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

  def self.redis_status
    service_status = ServiceStatus.new(name: "redis", type: :db)
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
