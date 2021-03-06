# -*- encoding : utf-8 -*-
require 'spec_helper'

describe OmniAuthConfigure::Configuration do
  def config_from(&block)
    OmniAuthConfigure::Configuration.new(&block)
  end

  describe '#parameters_for' do
    let(:config) do 
      config_from { 
        central File.expand_path("../test_configuration.yml", __FILE__) 
      }
    end

    let (:northwestern) do
      config.parameters_for(:patient_tracker, :northwestern) 
    end

    let (:facebook) do
      config.parameters_for(:patient_tracker, :facebook)
    end

    it 'aquires the default parameters' do
      expect(northwestern[:client_options][:site]).to eq('http://northwestern.edu')
    end

    it 'aquires the parameters' do
      expect(northwestern[:client_id]).to eq('c1980')
      expect(facebook[:client_id]).to eq('c1995')
    end

    it 'aquires the overridden parameters' do
      expect(northwestern[:client_options][:token_url]).to eq('/override/token')
    end
  end

  describe '#strategies' do
    it 'stores strategies' do
      c = config_from { strategies :nucats_accounts, :facebook, :twitter }
      expect(c.strategies).to eq([:nucats_accounts, :facebook, :twitter])
    end 
  end
end