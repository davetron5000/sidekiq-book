class ApplicationController < ActionController::Base
  before_action do
    @current_user = User.first
  end
end
