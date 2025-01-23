# frozen_string_literal: true

require 'git'

module Upgrader
  module Modules
    module Common
      class GitLabModule < BaseModule
        Upgrader::Modules.register_module('gitlab', self)
        Upgrader::Modules.register_step('common', 'gitlab', 'mr',
                                        'Will push the branch and will open a webpage to create the MR.')

        def mr
          frame_with_rescue('Creating merge request') do
            wait('Pushing branch') { push_branch }
            wait('Creating merge request') { create_merge_request }
          end
        end

        private

        def git
          @git ||= Git.open(@project.path)
        end

        def push_branch
          raise 'There are uncommitted changes in the project' if git.status.untracked.count.positive? || git.status.changed.count.positive?

          git.push('origin', branch_name)
        end

        def create_merge_request
          `open #{url}`
        end

        def url
          repo = git.remote.url.match(/git@(.+):(.+).git/)[2]
          "https://gitlab.com/#{repo}/-/merge_requests/new?merge_request%5Bsource_branch%5D=#{branch_name}"
        end
      end
    end
  end
end
