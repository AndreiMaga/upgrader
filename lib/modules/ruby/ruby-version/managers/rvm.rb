# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module Managers
        class Rvm
          def self.list_of_versions
            raise NotImplementedError
          end
        end
      end
    end
  end
end
