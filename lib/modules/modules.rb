# frozen_string_literal: true

require_relative './base'
require_relative './git'
require_relative './bundle'

module Upgrader
  module Modules
    MODULES = {
      'git' => GitModule,
      'bundle' => BundleModule
    }.freeze
  end
end
