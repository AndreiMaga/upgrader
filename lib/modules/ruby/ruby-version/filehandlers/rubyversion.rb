# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class RubyVersion < BaseFileHandler
          FILENAME = '.ruby-version'
          PATTERN = /^(\d*.\d*.\d*)/
          GSUB_PATTERN = /[\d.]{1,5}/
          SKIP_ON_MULTIPLE = true

          def gsub_replace
            "\\1#{@new_version}"
          end
        end
      end
    end
  end
end
