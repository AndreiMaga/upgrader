# frozen_string_literal: true

module Upgrader
  module CLI
    def wait(title, &block)
      @spin_group = ::CLI::UI::SpinGroup.new
      @spin_group.add(title, &block)
      @spin_group.wait

      exit!(1) unless @spin_group.all_succeeded?
    end

    def frame_with_rescue(title, &block)
      ::CLI::UI::Frame.open("#{title} #{project_name}", &block)
    rescue StandardError => e
      puts ::CLI::UI.fmt("{{red:#{title} - #{e.message}}}")
      exit!(1)
    end

    def project_name
      "(#{@project.name})" if @project
    end
  end
end
