# frozen_string_literal: true

require_relative './claude'

module Upgrader
  module Modules
    module Common
      module Ai
        module Adapters
          ADAPTERS = { claude: Claude }.freeze

          module_function

          def adapter
            @adapter ||= ADAPTERS[::Config.ai[:adapter].to_sym]
          end
        end
      end
    end
  end
end
