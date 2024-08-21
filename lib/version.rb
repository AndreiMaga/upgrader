# frozen_string_literal: true

require 'net/http'

module Upgrader
  class Version
    class << self
      def check
        return if ENV['CI'] || Config.misc.fetch(:skip_version_check, false)

        latest = Gem::Version.new(fetch_latest)

        return unless latest > current

        ::CLI::UI.puts ::CLI::UI.fmt "\n{{*}} New upgrader version available: #{latest}\n"
      end

      private

      def fetch_latest
        uri = URI('https://raw.githubusercontent.com/AndreiMaga/upgrader/main/version')

        response = Net::HTTP.get(uri)

        response&.to_s&.strip
      end

      def current
        Gem::Version.new(File.read(File.expand_path('../version', __dir__)).strip)
      end
    end
  end
end
