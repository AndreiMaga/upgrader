# frozen_string_literal: true

require_relative './base'

module Upgrader
  module Modules
    module_function

    def modules
      @modules ||= {}
    end

    def register_module(name, klass)
      modules[name] = klass
    end
  end
end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |file| require file }
