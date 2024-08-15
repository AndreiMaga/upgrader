# frozen_string_literal: true

require 'open3'
module Upgrader
  module Modules
    class BundleModule < BaseModule
      def update
        ::CLI::UI::Frame.open("bundle update (#{@project.name})") do |_frame|
          store_gems(:before)
          wait('Updating gems') { update_gems }
          store_gems(:after)
          changes = ::CLI::UI.ask('Show changes? [y/n]')
          show_changes if changes.downcase == 'y'
        end
      end

      private

      def update_gems
        Bundler.with_original_env do
          Dir.chdir(@project.path) { `bundle update` }
        end
      end

      def store_gems(key)
        lock_file = File.join(@project.path, 'Gemfile.lock')

        raise 'Lock file not found' unless File.exist?(lock_file)

        contents = Bundler.read_file(lock_file)

        parsed_gems = ::Bundler::LockfileParser.new(contents)
        gems[key] = parsed_gems.specs.each_with_object({}) do |spec, hash|
          hash[spec.name] = spec.version.version
        end
      end

      def gems
        @gems ||= {}
      end

      def show_changes
        HashDiff.new(gems[:before], gems[:after]).print
      end
    end

    class HashDiff
      def initialize(before, after)
        @before = before
        @after = after
      end

      def sign(key)
        if @before[key] == @after[key]
          nil
        elsif @before[key].nil?
          '{{green:+}}'
        elsif @after[key].nil?
          '{{red:-}}'
        else
          '{{yellow:~}}'
        end
      end

      def print
        ::CLI::UI.puts ''
        diff.each do |key, values|
          ::CLI::UI.puts ::CLI::UI.fmt "#{values[:changes]} #{key}: #{values[:before]} -> #{values[:after]}"
        end
      end

      def diff
        @diff ||= @before.keys.concat(@after.keys).uniq.each_with_object({}) do |key, hash|
          sign = sign(key)
          next unless sign

          hash[key] = {
            before: @before[key] || nil,
            after: @after[key] || nil,
            changes: sign(key)
          }
        end
      end
    end
  end
end
