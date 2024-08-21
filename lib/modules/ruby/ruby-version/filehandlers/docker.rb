# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class Docker < BaseFileHandler
          FILENAME = 'Dockerfile'
          PATTERN  = /^FROM ruby:([\d.]{1,5})/

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

          def update_file!(path)
            new_content = content(path).gsub(/(^FROM ruby:)([\d.]{1,5})/, "\\1#{@new_version}")
            save_content(path, new_content)
          end
        end
      end
    end
  end
end
