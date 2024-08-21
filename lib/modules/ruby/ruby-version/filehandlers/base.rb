# frozen_string_literal: true

require 'English'

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class BaseFileHandler
          include CLI

          def self.inherited(klass) # rubocop:disable Lint/MissingSuper
            ::Upgrader::Modules::Ruby::FileHandlers.register_file_handler(klass.to_s, klass)
          end

          def filename
            self.class::FILENAME
          end

          def initialize(project, new_version)
            @project = project
            @new_version = new_version
          end

          def file_paths
            return Dir["#{@project.path}/#{filename}"] if File.exist?("#{@project.path}/#{filename}")

            Dir["#{@project.path}/**/#{filename}"]
          end

          def content(path)
            File.read(path)
          end

          def save_content(path, content)
            File.open(path, 'w') do |file|
              file.puts content
            end
          end
        end
      end
    end
  end
end
