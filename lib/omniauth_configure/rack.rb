module OmniAuthConfigure::Rack
  def self.use_in(builder, configuration=nil, &block)
    effective_configuration = configuration || OmniAuthConfigure.configuration
    unless effective_configuration
      fail "No configuration was provided. " <<
        "Please set one or the other before calling use_in."
    end

    app = effective_configuration.app
    klasses = effective_configuration.strategies

    klasses.each do |klass|
      if klass.is_a?(Class)
        middleware = klass
      else
        begin
          middleware = OmniAuth::Strategies.const_get("#{OmniAuth::Utils.camelize(klass.to_s)}")
        rescue NameError
          raise LoadError, "Could not find matching strategy for #{klass.inspect}. You may need to install an additional gem (such as omniauth-#{klass})."
        end
      end

      p = effective_configuration.parameters_for(app, klass)

      middleware.args [:client_id, :client_secret]

      cid = p[:client_id]
      cs  = p[:client_secret]
      s   = p[:site]
      au  = p[:authorize_url]
      tu  = p[:token_url]

      args = [cid, cs]
      if s || au || tu
        middleware.args [:client_id, :client_secret, :client_options]
        args << {:site => s, :authorize_url => au, :token_url => tu }
      end
      args << {} # Last argument to provider strategy is empty hash

      builder.use middleware, *args, &block
    end
  end
end