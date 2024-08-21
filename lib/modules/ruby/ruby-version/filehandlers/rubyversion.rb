# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class RubyVersion < BaseFileHandler
          FILENAME = '.ruby-version'
          PATTERN = /^ruby-(\d*.\d*.\d*)/
          GSUB_PATTERN = /(^ruby-)([\d.]{1,5})/
          GSUB_REPLACE = "\\1#{@new_version}"
          SKIP_ON_MULTIPLE = true
        end
      end
    end
  end
end
