# frozen_string_literal: true

module Upgrader
  class Project
    attr_reader :name, :path

    def initialize(name:, opts:)
      @name = name
      @path = opts[:path]
      @steps = opts[:steps] || []
      @behaviour = opts[:behaviours] || {}
    end

    def upgrade
      raise 'No steps provided' if @steps.empty?

      @steps.each { |step| run_step(step) }
    end

    def behaviours(mod, key)
      result = @behaviour.fetch(mod, nil) || Config.behaviours.fetch(mod, nil)
      raise "No behaviour found for #{mod}" unless result
      raise "No key found for #{mod}" unless result.key?(key)

      result[key]
    end

    private

    def run_step(step)
      mod, fn = step.split(':')

      module_class = ::Upgrader::Modules::MODULES[mod]

      raise "Unknown module: #{mod}" unless module_class

      module_instance = module_class.new(self)

      if fn && module_instance.respond_to?(fn)
        module_instance.public_send(fn)
      else
        module_instance.run
      end
    end
  end
end
