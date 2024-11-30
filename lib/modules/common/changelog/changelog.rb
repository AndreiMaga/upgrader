# frozen_string_literal: true

module Upgrader
  module Modules
    module Common
      class ChangelogModule < BaseModule
        Upgrader::Modules.register_module('changelog', self)
        Upgrader::Modules.register_step('common', 'changelog', 'run',
                                        'Will add a changelog file to the `changelog/unreleased` folder, with the contents.')
        Upgrader::Modules.register_behaviour('common', 'changelog', 'title', 'The title of the changelog.')

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
end
