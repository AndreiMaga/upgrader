# frozen_string_literal: true

require_relative './adapters/adapters'

module Upgrader
  module Modules
    module Common
      class AiModule < BaseModule
        Upgrader::Modules.register_module('ai', self)
        Upgrader::Modules.register_step('common', 'ai', 'changes',
                                        'Analyses gem version changes using an AI adapter and reports breaking changes.')
        def changes
          frame_with_rescue('Analysing breaking changes') do
            gem_diff = @project.store[:gem_diff]
            raise 'No gem diff found. Run bundle:update before ai:changes' if gem_diff.nil? || gem_diff.empty?

            prompt = build_prompt(gem_diff)
            result = nil
            wait('Analysing breaking changes') { result = adapter.ask(prompt) }
            display(result)
          end
        end

        private

        def adapter
          Ai::Adapters.adapter.new
        end

        def build_prompt(gem_diff)
          <<~PROMPT
            The following Ruby gems were changed after a `bundle update`. For each gem that had a major or minor version bump, list any breaking changes, deprecations, or important migration notes.

            Skip gems that only had patch-level updates unless they contain known security fixes.
            Be concise. Group by gem name. If there are no notable changes for a gem, skip it entirely.

            Gem changes:
            #{gem_changes(gem_diff)}
          PROMPT
        end

        def gem_changes(gem_diff)
          gem_diff.map do |name, values|
            "#{name}: #{values[:before] || 'new'} -> #{values[:after] || 'removed'}"
          end.join("\n")
        end

        def display(result)
          ::CLI::UI.puts ''
          ::CLI::UI.puts result
          ::CLI::UI.puts ''

          exit!(1) unless ::CLI::UI::Prompt.confirm('Continue?')
        end
      end
    end
  end
end
