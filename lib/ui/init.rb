# frozen_string_literal: true

require 'cli/ui'

require_relative 'cli'

CLI::UI::StdoutRouter.enable
CLI::UI.frame_style = :bracket
