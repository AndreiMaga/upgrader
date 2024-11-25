# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class Gemfile < BaseFileHandler
          FILENAME = 'Gemfile'
          PATTERN = /^ruby ['"](\d*.\d*.\d*)['"]/
          GSUB_PATTERN = /(^ruby ['"])([\d.]{1,5})(['"])/
          SKIP_ON_MULTIPLE = true

          def gsub_replace
            "\\1#{@new_version}\\3"
          end
        end
      end
    end
  end
end
