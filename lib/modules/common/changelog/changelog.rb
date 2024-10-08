# frozen_string_literal: true

module Upgrader
  module Modules
    class ChangelogModule < BaseModule
      Upgrader::Modules.register_module('changelog', self)

      def run
        frame_with_rescue('Creating changelog') do
          wait('Creating changelog') { create_changelog }
        end
      end

      private

      def create_changelog
        File.open(File.join(@project.path, 'changelogs', 'unreleased', "#{branch_name}.yml"), 'w') do |file|
          file.write("---\ntitle: #{changelog}\n")
        end
      end

      def changelog
        @project.behaviours(:changelog, :title)
      end
    end
  end
end
