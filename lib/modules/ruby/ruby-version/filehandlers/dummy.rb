# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module FileHandlers
        class DummyHandler < BaseFileHandler
          FILENAME = 'dummy'
          PATTERN = /dummy/
          GSUB_PATTERN = /dummy/
          SKIP_ON_MULTIPLE = true
          AUTO_REGISTER = false
        end
      end
    end
  end
end
