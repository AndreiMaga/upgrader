# frozen_string_literal: true

require_relative 'init/boot'

module Upgrader
  class Upgrader
    include CLI

    def run
      version_check
      load_projects

      @projects.each do |name, opts|
        frame_with_rescue("Upgrading #{name}") do |_frame|
          Project.new(name:, opts:).upgrade
        end
      end
    end

    private

    def version_check
      ::Upgrader::Version.check
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
