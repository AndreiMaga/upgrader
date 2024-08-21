# frozen_string_literal: true

require_relative 'managers/manager'
require_relative 'filehandlers/filehandlers'

module Upgrader
  module Modules
    class RubyVersionModule < BaseModule
      ::Upgrader::Modules.register_module('ruby-version', self)

      def run
        frame_with_rescue('Changing Ruby version') do
          current_version
          pick_version
          confirm_change
          change_version
        end
      end

      private

      def change_version
        raise SkipFrame if @version == @current

        @manager.install_version(@version)

        # handle file changes
        ::Upgrader::Modules::Ruby::FileHandlers.run_file_handlers(@project, @version)
      end

      def current_version
        @current ||= File.read(File.join(@project.path, '.ruby-version')).strip
        raise 'Cannot get current Ruby version' if @current.empty?
      end

      def pick_version
        manager_class = ::Upgrader::Modules::Ruby::Managers.manager

        @manager = manager_class.new(@project) if manager_class

        list = ['custom']

        list += @manager.list_of_versions if @manager

        @version = ::CLI::UI::Prompt.ask("Pick Ruby version (current: #{@current})", options: list)

        custom_version if @version == 'custom'
      end

      def custom_version
        @version = ::CLI::UI.ask('Select a custom version', default: @current)
        ::CLI::UI.puts ''

        raise 'Invalid Ruby version' if @version.empty?
      end

      def confirm_change
        return if ::CLI::UI::Prompt.confirm("Are you sure you want to change versions from #{@current} to #{@version}?")

        raise 'Cannot continue due to user input'
      end
    end
  end
end
