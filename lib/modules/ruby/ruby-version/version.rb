# frozen_string_literal: true

require_relative 'managers/manager'
require_relative 'filehandlers/filehandlers'

module Upgrader
  module Modules
    module Ruby
      class RubyVersionModule < BaseModule
        ::Upgrader::Modules.register_module('ruby-version', self)
        ::Upgrader::Modules.register_step('ruby', 'ruby-version', 'run', <<~RVERS
          Will prompt the user for a ruby version to update to, after that will install the version (if not already installed).
          Once the version is installed, it will run the file handlers, these will go through the specified files and update the ruby version inside.

          Adding `ruby-version` will automatically run `bundle:install` after it

          ##### Files supported
          - Dockerfile
          - Gemfile
          - .gitlab-ci.yml
          - .rubocop.yml
          - .ruby-version
        RVERS
        )
        ::Upgrader::Modules.register_behaviour('ruby', 'ruby-version', 'version',
                                               'Setting the version will skip the prompt to input it.')

        def run
          frame_with_rescue('Changing Ruby version') do
            current_version
            pick_version
            confirm_change
            change_version
            # this will run bundle install, since after doing a ruby version change
            # the gems might need to be reinstalled
            @project.run_step('bundle:install')
          end
        end

        private

        def change_version
          raise SkipFrame if @version == @current

          @manager.install_version(@version) unless @skip_checks

          # handle file changes
          ::Upgrader::Modules::Ruby::FileHandlers.run_file_handlers(@project, @version)
        end

        def current_version
          @current ||= File.read(File.join(@project.path, '.ruby-version')).strip
          raise 'Cannot get current Ruby version' if @current.empty?
        end

        def pick_version
          if @project.behaviours(:ruby_version, :version)
            @skip_checks = true
            @version = @project.behaviours(:ruby_version, :version)
            return
          end

          manager_class = ::Upgrader::Modules::Ruby::Managers.manager

          @manager = manager_class.new(@project) if manager_class

          list = ['custom'] + (@manager.list_of_versions if @manager)

          @version = ::CLI::UI::Prompt.ask("Pick Ruby version (current: #{@current})", options: list)

          custom_version if @version == 'custom'
        end

        def custom_version
          @version = ::CLI::UI.ask('Select a custom version', default: @current)
          ::CLI::UI.puts ''

          raise 'Invalid Ruby version' if @version.empty?
        end

        def confirm_change
          return if @skip_checks
          return if ::CLI::UI::Prompt.confirm("Are you sure you want to change versions from #{@current} to #{@version}?")

          raise 'Cannot continue due to user input'
        end
      end
    end
  end
end
