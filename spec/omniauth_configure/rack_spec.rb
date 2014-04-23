# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'omniauth'

describe OmniAuthConfigure::Rack do
  describe '#use_in' do
    let(:builder) { OmniAuthConfigure::Spec::MockBuilder.new }

    it "fails with a useful message if there's no configuration" do
        builder.reset!
        OmniAuthConfigure.configuration = nil

        lambda { OmniAuthConfigure::Rack.use_in(builder) }.
          should raise_error(/Please set one or the other before calling use_in./)
      end

    it 'adds middleware' do
      OmniAuthConfigure.configure {
        app :patient_tracker
        strategies :northwestern, :facebook
        central File.expand_path("../test_configuration.yml", __FILE__) 
      }

      OmniAuthConfigure::Rack.use_in(builder)
      expect(builder.uses[0].first).to eq(OmniAuth::Strategies::Northwestern)
      expect(builder.uses[0].first.args).to eq([:client_id, :client_secret, :client_options])

      expect(builder.uses[1].first).to eq(OmniAuth::Strategies::Facebook)
      expect(builder.uses[1].first.args).to eq([:client_id, :client_secret])
    end
  end
end

module OmniAuthConfigure
  module Spec
    ##
    # Record only version of Rack::Builder taken
    # from Aker
    #
    # @see https://github.com/NUBIC/aker
    #      Aker: a flexible security framework for Rack (and Rails)
    class MockBuilder
      def reset!
        self.uses.clear
      end

      def use(cls, *params, &block)
        self.uses << [cls, params, block]
      end

      def uses
        @uses ||= []
      end

      def using?(klass, *params)
        self.uses.detect { |cls, prms, block| cls == klass && params == prms }
      end

      alias :find_use_of :using?
    end
  end
end

module OmniAuth
  module Strategies
    class Northwestern
     include OmniAuth::Strategy
    end
    class Facebook
     include OmniAuth::Strategy
    end
  end
end