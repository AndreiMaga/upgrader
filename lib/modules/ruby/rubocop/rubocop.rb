# frozen_string_literal: true

module Upgrader
  module Modules
    class RubocopModule < BaseModule
      Upgrader::Modules.register_module('rubocop', self)

      def run
        frame_with_rescue('Running Rubocop') do
          wait('Running Rubocop') { run_rubocop }
        end
      end

      def fix
        frame_with_rescue('Running Rubocop -a') do
          wait('Running Rubocop') { run_rubocop('-a') }
        end
      end

      private

      def setup_env(&block)
        Bundler.with_original_env do
          Dir.chdir(@project.path, &block)
        end
      end

      def run_rubocop(opts = '')
        setup_env { runner(opts) }
      end

      def runner(opts = '')
        output = `bundle exec rubocop #{opts} 2> /dev/null`
        result = output[/(\d+) files inspected, (\d+) offenses detected, (\d+) offenses autocorrectable/]

        return when_needs_correction(result) if result

        result = output[/(\d+) files inspected, (\d+) offenses detected, (\d+) offenses corrected/]

        return when_correcting(result) if result

        result ||= output[/(\d+) files inspected, no offenses detected/]

        raise 'Cannot get output from Rubocop' unless result
      end

      def when_needs_correction(result)
        _, offenses, = result.split(',').map { |s| s[/\d+/].to_i }

        raise "#{offenses} offenses detected" if offenses.positive?
      end

      def when_correcting(result)
        _, offenses, corrected = result.split(',').map { |s| s[/\d+/].to_i }

        raise "#{offenses} offenses detected" if offenses.positive? && offenses != corrected
      end
    end
  end
end
