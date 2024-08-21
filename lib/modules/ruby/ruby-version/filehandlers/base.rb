# frozen_string_literal: true

require 'English'

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class BaseFileHandler
          include CLI

          def initialize(project, new_version)
            @project = project
            @new_version = new_version
          end

          def run
            paths = file_paths

            return if skip?(paths)

            wait("Updating #{filename} ") do
              paths.each { |path| update_file!(path) }
            end
          rescue StandardError
            puts "Could not update #{filename} because #{$ERROR_INFO.message}"
          end

          def self.inherited(klass) # rubocop:disable Lint/MissingSuper
            ::Upgrader::Modules::Ruby::FileHandlers.register_file_handler(klass.to_s, klass)
          end

          private

          def skip?(paths)
            if paths.empty?
              puts "No #{filename} found"
              return true
            end

            if self.class::SKIP_ON_MULTIPLE && paths.length > 1
              puts "Multiple #{filename} found, skipping"
              return true
            end

            false
          end

          def update_file!(path)
            new_content = content(path).gsub(gsub_pattern, gsub_replace)
            save_content(path, new_content)
          end

          def gsub_pattern
            self.class::GSUB_PATTERN
          end

          def gsub_replace
            self.class::GSUB_REPLACE
          end

          def filename
            self.class::FILENAME
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
