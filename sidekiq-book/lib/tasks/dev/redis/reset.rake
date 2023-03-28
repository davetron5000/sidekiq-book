namespace :dev do
  namespace :redis do
    desc "Reset Redis back to a clean state"
    task reset: :environment do
      if Rails.env.development? || Rails.env.test?
        redis = Redis.new(url: ENV["SIDEKIQ_REDIS_URL"])
        redis.flushall
        puts "[ dev:redis:reset ] All redis dbs flushed"
      else
        puts "!!!! You cannot dev:redis:reset outside of development or test !!!"
      end
    end
  end
end
