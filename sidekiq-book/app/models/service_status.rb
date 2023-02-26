class ServiceStatus
  include ActiveModel::Model

  attr_accessor :name, :status, :info

  def good!(info)
    self.status = true
    self.info = info
  end

  def problem!(problem_or_exception)
    self.status = problem_or_exception
    self.info = {}
  end
end
