# frozen_string_literal: true

require_relative 'init/boot'

module Upgrader
  class Upgrader
    include CLI

    def run
      wait('Loading projects') do
        @projects = Config.projects

        raise 'No projects found' if @projects.empty?
      end

      @projects.each do |name, opts|
        frame_with_rescue("Upgrading #{name}") do |frame|
          Project.new(name:, opts:, frame:).upgrade
        end
      end
    end
  end
end
Upgrader::Upgrader.new.run
