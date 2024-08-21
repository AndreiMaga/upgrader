# frozen_string_literal: true

require 'English'

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class Docker
          include CLI
          ::Upgrader::Modules::Ruby::FileHandlers.register_file_handler('docker', self)

          FILENAME = 'Dockerfile'
          PATTERN  = /^FROM ruby:([\d.]{1,5})/

          def initialize(project, new_version)
            @project = project
            @new_version = new_version
          end

          def run
            paths = file_paths

            if paths.empty?
              puts 'No Dockerfiles found'
              return
            end

            wait('Updating Dockerfiles') do
              paths.each { |path| update_file!(path) }
            end
          rescue StandardError
            puts "Could not update Dockerfiles because #{$ERROR_INFO.message}"
          end

          private

          def file_paths
            Dir["#{@project.path}/**/#{FILENAME}"]
          end

          def update_file!(path)
            new_content = content(path).gsub(/(^FROM ruby:)([\d.]{1,5})/, "\\1#{@new_version}")
            file = File.open(path, 'w')
            file.puts new_content
            file.close
          end

          def content(path)
            File.read(path)
          end
        end
      end
    end
  end
end
