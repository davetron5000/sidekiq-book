require "net/http"

class WelcomeController < ApplicationController
  def show
    @service_statuses = ServiceStatus.all
  end
end
