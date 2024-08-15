# frozen_string_literal: true

module Upgrader
  module CLI
    def wait(title, &block)
      @spin_group = ::CLI::UI::SpinGroup.new
      @spin_group.add(title, &block)
      @spin_group.wait
      raise "#{title} - Failed" unless @spin_group.all_succeeded?
    end
  end
end
