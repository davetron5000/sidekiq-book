namespace :dev do
  namespace :cache do
    desc "Reset the dev cache"
    task reset: :environment do
      if Rails.env.development? || Rails.env.test?
        system("rm -rf /tmp/rails-cache")
        puts "[ dev:cache:reset ] File cache reset"
      else
        puts "!!!! You cannot dev:redis:reset outside of development or test !!!"
      end
    end
  end
end
