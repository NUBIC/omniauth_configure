# -*- encoding : utf-8 -*-
require File.join('omniauth_configure', 'central_parameters')
require File.join('omniauth_configure', 'configuration')
require File.join('omniauth_configure', 'rack')
require File.join('omniauth_configure', 'railtie') if defined?(Rails)

module OmniAuthConfigure
  class << self
    attr_accessor :configuration
  end

  def self.configure(&block)
    @configuration ||= OmniAuthConfigure::Configuration.new
    @configuration.enhance(&block)
  end
end