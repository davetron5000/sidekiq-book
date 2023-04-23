namespace :dev do
  desc "Reset the fake API, Redis, and the Rails cache"
  task reset: :environment do
    if Rails.env.development? || Rails.env.test?
      puts "[ dev:reset ] Clearing Rails cache for #{Rails.env}"
      system("rm -rf /tmp/rails-cache")
      puts "[ dev:reset ] Clearing email service state for #{Rails.env}"
      EmailServiceWrapper.new.clear!
      puts "[ dev:reset ] Clearing error catcher state for #{Rails.env}"
      ErrorCatcherServiceWrapper.new.clear!
      puts "[ dev:reset ] Clearing fulfillment services state for #{Rails.env}"
      FulfillmentServiceWrapper.new.clear!
      puts "[ dev:reset ] Clearing payments service state for #{Rails.env}"
      PaymentsServiceWrapper.new.clear!
      puts "[ dev:reset ] Clearing Redis for #{Rails.env}"
      redis = Redis.new(url: ENV["SIDEKIQ_REDIS_URL"])
      redis.flushall
      puts "[ dev:reset ] Done resetting #{Rails.env}"
    else
      puts "!!!! You cannot dev:reset outside of development or test !!!"
    end
  end
end


