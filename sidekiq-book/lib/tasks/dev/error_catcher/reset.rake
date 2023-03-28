namespace :dev do
  namespace :error_catcher do
    desc "Reset mock error-catcher back to a clean state"
    task reset: :environment do
      if Rails.env.development? || Rails.env.test?
        ErrorCatcherServiceWrapper.new.clear!
        puts "[ dev:error_catcher:reset ] Reset!"
      else
        puts "!!!! You cannot dev:redis:reset outside of development or test !!!"
      end
    end
  end
end
