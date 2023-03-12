class ServiceWrapperConfig

  def cache_key = self.service_name + ".config"

  def self.for(service_name)
    instance = self.new(service_name: service_name)
    instance.load_from_cache!
  end

  def update!(params)
    Rails.cache.write(self.cache_key,params)
  end

  attr_reader :sleep

  def initialize(service_name:, throttle: false, crash: false, sleep: 0)
    @service_name =   service_name
    self.throttle = throttle
    self.crash    = crash
    self.sleep    = sleep
  end
  def throttle? = @throttle
  def crash?    = @crash
  def sleep?    = @sleep > 0

  def load_from_cache!
    cached_config = Rails.cache.fetch(self.cache_key) do
      {
        throttle: false,
        crash: false,
        sleep: 0,
      }
    end
    self.throttle = cached_config["throttle"]
    self.crash    = cached_config["crash"]
    self.sleep    = cached_config["sleep"] || 0
    self
  end


protected

  attr_reader :service_name

  def throttle=(value)
    @throttle = !!value
  end
  def crash=(value)
    @crash = !!value
  end
  def sleep=(value)
    @sleep = [ Integer(value), 0 ].max
  end

end


