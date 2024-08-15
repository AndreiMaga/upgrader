# frozen_string_literal: true

require_relative './module'
require_relative './gitmodule'
require_relative './bundlemodule'

module Upgrader
  module Modules
    MODULES = {
      'git' => GitModule,
      'bundle' => BundleModule
    }.freeze
  end
end
