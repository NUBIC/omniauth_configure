# -*- encoding : utf-8 -*-
require 'yaml'
require 'active_support'

module OmniAuthConfigure
  class CentralParameters
    attr_writer :entries, :raw_values

    def entries
      @entries ||= {}
    end

    def raw_values
      @raw_values ||= {}
    end

    def initialize(file_path)
      @raw_values = YAML::load( File.open(file_path) )

      @raw_values = nested_symbolize_keys!(deep_clone(raw_values))
    end

    def [](app, provider)
      unless entries.key?(app)
        entries[app] = {}
        entries[app][provider] = 
            {}.deep_merge((raw_values[:default] || {})[provider] || {}).
            deep_merge((raw_values[:defaults] || {})[provider] || {}).
            deep_merge((raw_values[app] || {})[provider] || {})
      end
      entries[app][provider]
    end

    #######
    private

    def deep_clone(src)
      clone = { }
      src.each_pair do |k, v|
        clone[k] = v.is_a?(Hash) ? deep_clone(v) : v
      end
      clone
    end

    def nested_symbolize_keys!(target)
      target.keys.each do |k|
        v = target[k]
        nested_symbolize_keys!(v) if v.respond_to?(:keys)
        target.delete(k)
        target[k.to_sym] = v
      end
      target
    end
  end
end