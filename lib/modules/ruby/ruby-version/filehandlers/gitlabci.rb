# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class GitlabCI < BaseFileHandler
          FILENAME = '.gitlab-ci.yml'
          PATTERN = /image: ruby:([\d.]{1,5})/

          def run
            paths = file_paths

            return if skip?(paths)

            wait('Updating .gitlab-ci.yml') do
              paths.each { |path| update_file!(path) }
            end
          rescue StandardError
            puts "Could not update .gitlab-ci.yml because #{$ERROR_INFO.message}"
          end

          private

          def update_file!(path)
            new_content = content(path).gsub(/(image: ruby:)([\d.]{1,5})/, "\\1#{@new_version}")
            save_content(path, new_content)
          end

          def skip?(paths)
            if paths.empty?
              puts 'No GitlabCI files found'
              return true
            end

            false
          end
        end
      end
    end
  end
end
