# frozen_string_literal: true

module Upgrader
  module CLI
    class SkipFrame < StandardError; end

    def graceful_exit
      ::Upgrader::Save.save!
      abort 'Exiting...'
    end

    def wait(title, &block)
      if Config.options[:no_frame]
        puts title
        return block.call
      end

      @spin_group = ::CLI::UI::SpinGroup.new
      @spin_group.add(title, &block)
      @spin_group.wait

      graceful_exit unless @spin_group.all_succeeded?
    end

    def frame_with_rescue(title, &block)
      if Config.options[:no_frame]
        puts ::CLI::UI.fmt("#{title} #{project_name}")
        return block.call
      end

      ::CLI::UI::Frame.open("#{title} #{project_name}", &block)
    rescue SkipFrame
      puts ::CLI::UI.fmt("{{yellow:#{title} - skipped}}")
    rescue StandardError => e
      puts ::CLI::UI.fmt("{{red:#{title} - #{e.message}}}")
      graceful_exit
    end

    def project_name
      "(#{@project.name})" if @project
    end
  end
end
