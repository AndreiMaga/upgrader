# frozen_string_literal: true

module Upgrader
  module Modules
    module Ruby
      class RSpecModule < BaseModule
        Upgrader::Modules.register_module('rspec', self)
        Upgrader::Modules.register_step('ruby', 'rspec', 'run',
                                        'Will run `rspec` and if it fails, it will stop the execution.')

        def run
          frame_with_rescue('Running RSpec') do
            wait('Running RSpec') { run_rspec }
          end
        end

        private

        def run_rspec
          Bundler.with_original_env do
            Dir.chdir(@project.path) do
              output = Managers.manager.new(@project).run_command('bundle exec rspec 2> /dev/null')
              result = output[/(\d+) examples?, (\d+) failures?(, (\d+) pending)?/]

              raise 'Cannot get output from RSpec' unless result

              _, failures, = result.split(',').map { |s| s[/\d+/].to_i }

              raise "#{failures} example(s) failed" if failures.positive?
              raise "RSpec failed with output: #{output}" unless $CHILD_STATUS.success?
            end
          end
        end
      end
    end
  end
end
