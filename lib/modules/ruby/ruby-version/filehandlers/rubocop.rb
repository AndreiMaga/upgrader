# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class Rubocop < BaseFileHandler
          FILENAME = '.rubocop.yml'
          PATTERN = /TargetRubyVersion: (\d.\d)/
          GSUB_PATTERN = /(TargetRubyVersion: )(\d.\d)/
          SKIP_ON_MULTIPLE = false

          def gsub_replace
            "\\1#{@new_version}"
          end
        end
      end
    end
  end
end
