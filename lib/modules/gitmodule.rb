# frozen_string_literal: true

require 'git'
module Upgrader
  module Modules
    class GitModule < BaseModule
      def git
        @git ||= Git.open(@project.path)
      end

      def create
        wait('Checking out main') { checkout_main }
        wait('Creating branch and changelog') { create_branch_and_changelog }
      end

      def checkout_main
        git.checkout('main')
        git.fetch
        git.reset_hard
        git.clean(force: true)
      end

      def create_branch_and_changelog
        changelog = 'Upgrade ruby dependencies'
        branch_name = "#{Time.now.strftime('%Y%m%d')}_#{changelog.downcase.gsub(' ', '_')}"

        git.branch(branch_name).delete if git.branches.local.map(&:name).include?(branch_name)
        git.branch(branch_name).checkout

        write_changelog(branch_name, changelog)
      end

      def write_changelog(branch_name, changelog)
        File.open(File.join(@project.path, 'changelogs', 'unreleased', "#{branch_name}.yml"), 'w') do |file|
          file.write("---\ntitle: #{changelog}")
        end
      end
    end
  end
end
