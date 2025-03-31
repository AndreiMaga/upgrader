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

            Dir.chdir(@project.path) { `rbenv install #{version}` }
          end

          def version_already_installed(version)
            output = Dir.chdir(@project.path) { `rbenv versions`.split("\n").map { |v| v.split(' ')[0] } }
            output.include?(version)
          end

          def rb_vn
            File.readlines(File.join(@project.path, '.ruby-version'), 'r').first.strip
          end

          def run_command(command)
            Dir.chdir(@project.path) do
              Bundler.with_original_env do
                return `eval \"$(rbenv init - --no-rehash bash)\" && RBENV_VERSION=#{rb_vn} #{command}`
              end
            end
          end
        end
      end
    end
  end
end
