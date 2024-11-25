# frozen_string_literal: true

module Upgrader
  class Project
    attr_reader :name, :path

    def initialize(name:, opts:)
      @name = name
      @path = opts[:path]
      @steps = opts[:steps] || []
      @behaviour = opts[:behaviours] || {}
      @skip = opts[:skip] || false
    end

    def upgrade
      raise 'No steps provided' if @steps.empty?

      if @skip
        puts 'Project is marked as skip'
        return
      end

      @steps.each { |step| run_step(step) }
    end

    def behaviours(mod, key)
      result = @behaviour.fetch(mod, nil)
      result = Config.behaviours.fetch(mod, nil) unless result&.key?(key)
      raise "No behaviour found for #{mod}" unless result
      raise "No key found for #{key}" unless result.key?(key)

      result[key]
    end

    def run_step(step)
      mod, fn = step.split(':')

      module_class = ::Upgrader::Modules.modules[mod]

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
