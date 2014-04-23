require 'spec_helper'
require 'omniauth_configure'

describe OmniAuthConfigure::Configuration do
  def config_from(&block)
    OmniAuthConfigure::Configuration.new(&block)
  end

  let(:config) do 
    config_from { 
      central File.expand_path("../test_configuration.yml", __FILE__) 
    }
  end

  describe '#parameters_for' do
    let (:northwestern) do
      config.parameters_for(:patient_tracker, :northwestern) 
    end

    let (:facebook) do
      config.parameters_for(:patient_tracker, :facebook)
    end

    it 'aquires the default parameters' do
      expect(northwestern[:site]).to eq('http://northwestern.edu')
      expect(facebook[:site]).to eq('http://facebook.com')
    end

    it 'aquires the parameters' do
      expect(northwestern[:client_id]).to eq('c1980')
      expect(facebook[:client_id]).to eq('c1995')
    end

    it 'aquires the overridden parameters' do
      expect(northwestern[:token_url]).to eq('/override/token')
    end
  end
end