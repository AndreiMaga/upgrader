# frozen_string_literal: true

require_relative 'init/boot'

module Upgrader
  class Upgrader
    include CLI

    def run
      wait('Loading projects') { find_projects }

      @projects.each do |name, opts|
        ::CLI::UI::Frame.open("Upgrading #{name}") do |frame|
          upgrade_project(name, opts, frame)
        end
      end
    end

    private

    def find_projects
      @projects = Config.projects

      raise 'No projects found' if @projects.empty?
    end

    def upgrade_project(name, opts, frame)
      Project.new(name:, opts:, frame:).upgrade
    end
  end
end
Upgrader::Upgrader.new.run
