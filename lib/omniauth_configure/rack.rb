module OmniAuthConfigure::Rack
  def self.use_in(builder, configuration=nil, &block)
    effective_configuration = configuration || OmniAuthConfigure.configuration
    unless effective_configuration
      fail "No configuration was provided. " <<
        "Please set one or the other before calling use_in."
    end

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

      p = effective_configuration.parameters_for(:patient_tracker, klass)
      # args.last.is_a?(Hash) ? args.push(options.merge(args.pop)) : args.push(options)
      middleware.args [:client_id, :client_secret, :client_options]

      cid = p[:client_id]
      cs  = p[:client_secret]
      s   = p[:site]
      au  = p[:authorize_url]
      tu  = p[:token_url]

      args = [cid, cs, {:site => s, :authorize_url => au, :token_url => tu }, {}]
      builder.use middleware, *args, &block
    end
  end
end