# frozen_string_literal: true

require 'optparse'
require 'cli/ui'

CLI::UI::StdoutRouter.enable
CLI::UI.frame_style = :bracket

require_relative 'config'
require_relative '../save/save'
require_relative '../ui/cli'
require_relative '../modules/modules'
require_relative '../project'
require_relative '../version'
