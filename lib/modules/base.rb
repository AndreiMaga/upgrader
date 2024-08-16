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

      private

      def branch_name
        @branch_name ||= "#{Time.now.strftime('%Y%m%d')}_#{@project.behaviours(:git, :branch_prefix)}"
      end
    end
  end
end
