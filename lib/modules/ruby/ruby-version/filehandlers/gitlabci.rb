# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class GitlabCI < BaseFileHandler
          FILENAME = '.gitlab-ci.yml'
          PATTERN = /(image: .*ruby:)([\d.]{1,5})/
          GSUB_PATTERN = /(image: .*ruby:)([\d.]{1,5})/
          SKIP_ON_MULTIPLE = false

          def gsub_replace
            "\\1#{@new_version}"
          end
        end
      end
    end
  end
end
