# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      module Managers
        class Rbenv
          def initialize(project)
            @project = project
          end

          def list_of_versions
            output = Dir.chdir(@project.path) { `rbenv install -l`.split("\n").map { |v| v.gsub(' ', '') } }

            raise 'Cannot get list of Ruby versions' if output.empty?

            output
          end

          def install_version(version)
            if version_already_installed(version)
              puts "\nRuby version already installed\n\n"
              return
            end

            Dir.chdir(@project.path) { system("rbenv install #{version}") }
          end

          def version_already_installed(version)
            output = Dir.chdir(@project.path) { `rbenv versions`.split("\n").map { |v| v.split(' ')[0] } }
            output.include?(version)
          end
        end
      end
    end
  end
end
