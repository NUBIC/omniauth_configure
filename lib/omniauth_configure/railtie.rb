# -*- encoding : utf-8 -*-
module OmniAuthConfigure
  class Railtie < Rails::Railtie
    initializer 'OmniAuthConfigure::Rails middleware installation' do |app|
      Rails.logger.debug "Installing OmniAuthConfigure rack middleware"
      OmniAuthConfigure::Rack.use_in(app.middleware)
    end
  end
end