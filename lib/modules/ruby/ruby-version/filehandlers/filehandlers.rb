# frozen_string_literal: true

require_relative 'base'

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        module_function

        def file_handlers
          @file_handlers ||= {}
        end

        def register_file_handler(name, klass)
          file_handlers[name] = klass
        end

        def run_file_handlers(project, new_version)
          puts 'Running file handlers'
          file_handlers.each_value do |klass|
            klass.new(project, new_version).run
          end
          puts 'File handlers finished'
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |file| require file }
