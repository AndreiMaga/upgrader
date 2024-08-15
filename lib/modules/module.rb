# frozen_string_literal: true

module Upgrader
  module Modules
    class BaseModule
      include CLI
      def initialize(project)
        @project = project
      end

      def run
        raise NotImplementedError
      end
    end
  end
end
