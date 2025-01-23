# frozen_string_literal: false

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class Docker < BaseFileHandler
          FILENAME = 'Dockerfile'
          PATTERN  = /^FROM .*ruby:([\d.]{1,5})/
          GSUB_PATTERN = /(^FROM .*ruby:)([\d.]{1,5})/
          SKIP_ON_MULTIPLE = false

          def gsub_replace
            "\\1#{@new_version}"
          end
        end
      end
    end
  end
end
