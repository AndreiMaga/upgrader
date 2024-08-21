# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class Gemfile < BaseFileHandler
          FILENAME = 'Gemfile'
          PATTERN = /^ruby ['"](\d*.\d*.\d*)['"]/

          def run
            paths = file_paths

            return if skip?(paths)

            wait('Updating Gemfiles') do
              paths.each { |path| update_file!(path) }
            end
          rescue StandardError
            puts "Could not update Gemfiles because #{$ERROR_INFO.message}"
          end

          private

          def update_file!(path)
            new_content = content(path).gsub(/(^ruby ['"])([\d.]{1,5})(['"])/, "\\1#{@new_version}\\3")
            save_content(path, new_content)
          end

          def skip?(paths)
            if paths.empty?
              puts 'No Gemfiles found'
              return true
            end

            if paths.length > 1
              puts 'Multiple Gemfiles found, skipping'
              return true
            end

            false
          end
        end
      end
    end
  end
end
