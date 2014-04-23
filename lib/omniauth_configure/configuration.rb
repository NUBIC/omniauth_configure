module OmniAuthConfigure
  class Configuration < Struct.new(:central)
    attr_reader :strategies

    def initialize(&config)
      self.enhance(&config) if config
    end

    def strategies=(*strategies)
      @strategies ||= strategies
    end

    ##
    # Updates the configuration via the {ConfiguratorLanguage DSL}.
    #
    # @return [Configuration] itself
    def enhance(&additional_config)
      Configurator.new(self, &additional_config)
      self
    end

    def parameters_for(app, provider)
      ::OmniAuthConfigure::CentralParameters.new(central)[app, provider]
    end
  end

  module ConfiguratorLanguage
    def method_missing(m, *args, &block)
      if @config.respond_to?(:"#{m}=")
        @config.send(:"#{m}=", *args)
      else
        super
      end
    end
  end

  ##
  # @private
  class Configurator
    include ConfiguratorLanguage

    def initialize(target, &block)
      @config = target
      instance_eval(&block)
    end
  end
end