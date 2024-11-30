# frozen_string_literal: true

require 'git'

module Upgrader
  module Modules
    module Common
      class GitModule < BaseModule
        Upgrader::Modules.register_module('git', self)
        Upgrader::Modules.register_step('common', 'git', 'create', '
        - checkout main
        - perform a hard reset
        - clean the branch
        - create a branch with a changelog')
        Upgrader::Modules.register_step('common', 'git', 'commit', '
        - adds all changes
        - commits')
        Upgrader::Modules.register_behaviour('common', 'git', 'branch_name',
                                             'The branch name is created like this `<timestamp>_<branch_prefix>`')

        def create
          frame_with_rescue('Creating git branch') do
            wait('Checking out main') { checkout_main }
            wait('Creating branch') { create_branch }
          end
        end

        def commit
          frame_with_rescue('Committing changes') do
            wait('Committing all changes') { commit_all }
          end
        end

        private

        def git
          @git ||= Git.open(@project.path)
        end

        def commit_all
          git.add(all: true)
          git.commit(@project.behaviours(:git, :message))
        end

        def checkout_main
          git.checkout('main')
          git.fetch
          git.reset_hard
          git.clean(force: true)
        end

        def create_branch
          git.branch(branch_name).delete if git.branches.local.map(&:name).include?(branch_name)
          git.branch(branch_name).checkout
        end
      end
    end
  end
end
