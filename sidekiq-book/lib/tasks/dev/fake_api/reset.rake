namespace :dev do
  namespace :fake_api do
    desc "Reset fake api back to a clean state"
    task reset: :environment do
      if Rails.env.development? || Rails.env.test?
        ErrorCatcherServiceWrapper.new.clear!
        EmailServiceWrapper.new.clear!
        PaymentsServiceWrapper.new.clear!
        FulfillmentServiceWrapper.new.clear!
        puts "[ dev:fake_api:reset ] Reset!"
      else
        puts "!!!! You cannot dev:fake_api:reset outside of development or test !!!"
      end
    end
  end
end
