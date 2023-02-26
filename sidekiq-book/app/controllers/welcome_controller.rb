class WelcomeController < ApplicationController
  class ServiceStatus
    include ActiveModel::Model

    attr_accessor :name, :status, :info

    def status_summary_character = self.status == true ? "✅" : "❌"
  end
  def show
    @service_statuses = [
      postgres_status,
      redis_status,
    ]
  end

private

  def postgres_status
    status,info = begin
               Order.count
               [
                 true,
                 ActiveRecord::Base.connection.raw_connection.conninfo_hash.slice(:dbname,:hostaddr,:host,:port,:user)
               ]
             rescue => ex
               [ex,{}]
             end

      ServiceStatus.new(name: "postgres",
                        status: status,
                        info: info)
  end

  def redis_status
    redis = Redis.new(url: ENV["REDIS_URL"])
    status,info = begin
                    redis.set("diagnostic-time",Time.zone.now)
                    redis.get("diagnostic-time")
                    [true,redis.connection.to_h]
                  rescue => ex
                    [ex,{}]
                  end
      ServiceStatus.new(name: "redis",
                        status: status,
                        info: info)
  end
end
