# frozen_string_literal: true

require_relative './base'
require_relative './git'
require_relative './bundle'
require_relative './rspec'
require_relative './changelog'
require_relative './gitlab'

module Upgrader
  module Modules
    MODULES = {
      'git' => GitModule,
      'bundle' => BundleModule,
      'rspec' => RSpecModule,
      'changelog' => ChangelogModule,
      'gitlab' => GitLabModule
    }.freeze
  end
end
