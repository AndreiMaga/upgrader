# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class Rubocop < BaseFileHandler
          FILENAME = '.rubocop.yml'
          PATTERN = /TargetRubyVersion: (\d.\d)/
          GSUB_PATTERN = /(TargetRubyVersion: )(\d.\d)/
          GSUB_REPLACE = "\\1#{@new_version}"
          SKIP_ON_MULTIPLE = false
        end
      end
    end
  end
end
