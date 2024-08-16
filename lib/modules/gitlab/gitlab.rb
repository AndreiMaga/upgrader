# frozen_string_literal: true

require 'git'
require 'launchy'

module Upgrader
  module Modules
    class GitLabModule < BaseModule
      Upgrader::Modules.register_module('gitlab', self)

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
        if git.status.untracked.count.positive? || git.status.changed.count.positive?
          raise 'There are uncommitted changes in the project'
        end

        git.push('origin', branch_name)
      end

      def create_merge_request
        Launchy.open(url)
      end

      def url
        repo = git.remote.url.match(/git@(.+):(.+).git/)[2]
        "https://gitlab.com/#{repo}/-/merge_requests/new?merge_request%5Bsource_branch%5D=#{branch_name}"
      end
    end
  end
end
