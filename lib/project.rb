# frozen_string_literal: true

module Upgrader
  class Project
    attr_reader :name, :path, :frame

    def initialize(name:, opts:, frame:)
      @name = name
      @path = opts[:path]
      @steps = opts[:steps] || []
      @frame = frame
    end

    def upgrade
      raise 'No steps provided' if @steps.empty?

      @steps.each { |step| run_step(step) }
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
