require File.join('omniauth_configure', 'central_parameters')
require File.join('omniauth_configure', 'configuration')

module OmniAuthConfigure
  class << self
    attr_accessor :configuration
  end

  def self.configure(&block)
    @configuration ||= OmniAuthConfigure::Configuration.new
    @configuration.enhance(&block)
  end
end