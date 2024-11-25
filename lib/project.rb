# frozen_string_literal: true

module Upgrader
  class Project
    attr_reader :name, :path, :skip, :finished_steps

    def initialize(name:, opts:)
      @name = name
      @path = opts[:path]
      @finished_steps = opts[:finished_steps] || []
      @steps = opts[:steps] || []
      @behaviour = opts[:behaviours] || {}
      @skip = opts[:skip] || false
      ::Upgrader::Save.register_project(self)
    end

    def upgrade
      if @skip || @steps.empty?
        puts 'Project is marked as skip or no steps were provided'
        return
      end

      run_steps
    end

    def run_steps
      @steps.each do |step|
        if @finished_steps.include?(step)
          puts "Skipping #{step} as it was already run"
          next
        end

        run_step(step)
        @finished_steps << step
      end
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
