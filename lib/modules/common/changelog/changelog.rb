# frozen_string_literal: true

module Upgrader
  module Modules
    module Common
      class ChangelogModule < BaseModule
        Upgrader::Modules.register_module('changelog', self)
        Upgrader::Modules.register_step('common', 'changelog', 'run',
                                        'Will add a changelog file to the `changelog/unreleased` folder, with the contents.')
        Upgrader::Modules.register_behaviour('common', 'changelog', 'title', 'The title of the changelog.')
        Upgrader::Modules.register_behaviour('common', 'changelog', 'ai_title',
                                             'Set to true to generate the changelog title using AI.')

        def run
          frame_with_rescue('Creating changelog') do
            generate_ai_title if @project.behaviours(:changelog, :ai_title)
            wait('Creating changelog') { create_changelog }
          end
        end

        private

        def generate_ai_title
          return if @project.store[:changelog_title]

          gem_diff = @project.store[:gem_diff]
          ruby_version = @project.store[:ruby_version]
          return unless gem_diff&.any? || ruby_version

          result = nil
          wait('Generating changelog title') { result = Ai::Adapters.adapter.new.ask(changelog_prompt(gem_diff, ruby_version)) }
          @project.store[:changelog_title] = result.strip
        end

        def changelog_prompt(gem_diff, ruby_version)
          changes = gem_diff&.map { |name, v| "#{name}: #{v[:before] || 'new'} -> #{v[:after] || 'removed'}" }

          <<~PROMPT
            Generate a single-line changelog title for a Ruby dependency upgrade.
            It should be short, descriptive, and suitable for a YAML changelog entry.
            Do not use quotes or special YAML characters. Only return the title, nothing else.
            #{ruby_version ? "\nRuby version: #{ruby_version[:from]} -> #{ruby_version[:to]}" : ''}
            #{changes ? "\nGem changes:\n#{changes.join("\n")}" : ''}
          PROMPT
        end

        def create_changelog
          File.open(File.join(@project.path, 'changelogs', 'unreleased', "#{branch_name}.yml"), 'w') do |file|
            file.write("---\ntitle: #{changelog}\n")
          end
        end

        def changelog
          @project.store[:changelog_title] || @project.behaviours(:changelog, :title)
        end
      end
    end
  end
end
