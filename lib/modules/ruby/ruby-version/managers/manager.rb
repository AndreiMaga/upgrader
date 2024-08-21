# frozen_string_literal: true

require_relative './rvm'
require_relative './rbenv'

module Upgrader
  module Modules
    module Ruby
      module Managers
        MANAGERS = { 'rvm': Rvm, 'rbenv': Rbenv }.freeze

        module_function

        def manager
          @manager ||= MANAGERS[::Config.languages[:ruby][:manager].to_sym]
        end
      end
    end
  end
end
