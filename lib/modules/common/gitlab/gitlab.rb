# frozen_string_literal: true

require 'git'
require 'shellwords'

module Upgrader
  module Modules
    module Common
      class GitLabModule < BaseModule
        Upgrader::Modules.register_module('gitlab', self)
        Upgrader::Modules.register_step('common', 'gitlab', 'mr',
                                        'Will push the branch and create the MR using the glab CLI.')
        Upgrader::Modules.register_behaviour('common', 'gitlab', 'ai_summary',
                                             'Set to true to generate an AI-powered MR description from the gem diff.')

        def mr
          frame_with_rescue('Creating merge request') do
            generate_summary if @project.behaviours(:gitlab, :ai_summary)
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

        def generate_summary
          return if @project.store[:mr_summary]

          gem_diff = @project.store[:gem_diff]
          return unless gem_diff&.any?

          result = nil
          wait('Generating MR summary') { result = Ai::Adapters.adapter.new.ask(summary_prompt(gem_diff)) }
          @project.store[:mr_summary] = result.strip
        end

        def summary_prompt(gem_diff)
          changes = gem_diff.map { |name, v| "#{name}: #{v[:before] || 'new'} -> #{v[:after] || 'removed'}" }

          <<~PROMPT
            Generate a concise GitLab MR description for a Ruby dependency upgrade in markdown.
            Include a brief summary, notable gem changes (skip patch-only updates), and any security fixes.
            Do not include a title, only the body.

            Gem changes:
            #{changes.join("\n")}
          PROMPT
        end

        def create_merge_request
          cmd = build_mr_command
          output = Dir.chdir(@project.path) { `#{cmd.shelljoin} 2>&1` }
          raise "Failed to create merge request:\n#{output}" unless Process.last_status.success?

          ::CLI::UI.puts ''
          output.each_line { |line| ::CLI::UI.puts line.chomp }
        end

        def build_mr_command
          cmd = ['glab', 'mr', 'create',
                 '--source-branch', branch_name,
                 '--title', @project.behaviours(:git, :message),
                 '--remove-source-branch']

          summary = @project.store[:mr_summary]
          cmd.push('--description', summary) if summary
          cmd
        end
      end
    end
  end
end
