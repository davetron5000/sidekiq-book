namespace :dev do
  desc "Reset the fake API, Redis, and the Rails cache"
  task reset: :environment do
    if Rails.env.development? || Rails.env.test?
      puts "[ dev:reset ] Clearing Rails cache"
      system("rm -rf /tmp/rails-cache")
      puts "[ dev:reset ] Clearing email service state"
      EmailServiceWrapper.new.clear!
      puts "[ dev:reset ] Clearing error catcher state"
      ErrorCatcherServiceWrapper.new.clear!
      puts "[ dev:reset ] Clearing fulfillment services state"
      FulfillmentServiceWrapper.new.clear!
      puts "[ dev:reset ] Clearing payments service state"
      PaymentsServiceWrapper.new.clear!
      puts "[ dev:reset ] Clearing Redis"
      redis = Redis.new(url: ENV["SIDEKIQ_REDIS_URL"])
      redis.flushall
      puts "[ dev:reset ] Done"
    else
      puts "!!!! You cannot dev:reset outside of development or test !!!"
    end
  end
end


