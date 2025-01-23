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
          puts "Running file handlers\n\n"
          file_handlers.each_value do |klass|
            klass.new(project, new_version).run
          end
          puts "\nFile handlers finished"
        end

        def clear_file_handlers
          @file_handlers = {}
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |file| require file }
