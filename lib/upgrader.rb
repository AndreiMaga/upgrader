# frozen_string_literal: true

require_relative 'init/boot'

module Upgrader
  class Upgrader
    include CLI

    def initialize
      setup_save
      version_check
    end

    def run
      load_projects
      load_save

      @projects.each do |name, opts|
        opts = ::Upgrader::Save.build_opts(name, opts)

        frame_with_rescue("Upgrading #{name}") do |_frame|
          Project.new(name:, opts:).upgrade
        end
      end
      save
    end

    private

    def save
      ::Upgrader::Save.save!
    end

    def trap_signal(signal)
      Signal.trap(signal) do
        save
        exit
      end
    end

    def setup_save
      trap_signal('INT')
      trap_signal('TERM')
    end

    def version_check
      ::Upgrader::Version.check
    end

    def load_save
      ::Upgrader::Save.load!
    end

    def load_projects
      wait('Loading projects') do
        @projects = Config.projects

        raise 'No projects found' if @projects.empty?
      end
    end
  end
end
Upgrader::Upgrader.new.run
