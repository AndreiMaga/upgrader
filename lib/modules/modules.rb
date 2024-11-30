# frozen_string_literal: true

require_relative './base'

module Upgrader
  module Modules
    module_function

    def modules
      @modules ||= {}
    end

    def steps
      @steps ||= {}
    end

    def behaviours
      @behaviours ||= {}
    end

    def register_module(name, klass)
      modules[name] = klass
    end

    def register_step(type, modul, step, comment)
      steps[type] ||= {}
      steps[type][modul] ||= {}
      steps[type][modul][step] = comment
    end

    def register_behaviour(type, modul, behaviour, value)
      behaviours[type] ||= {}
      behaviours[type][modul] ||= {}
      behaviours[type][modul][behaviour] = value
    end
  end
end

Dir["#{File.dirname(__FILE__)}/*/*/*.rb"].each { |file| require file }
