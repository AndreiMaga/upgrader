# frozen_string_literal: true

require 'yaml'

module Config
  module_function

  def config
    @config ||= YAML.load_file(File.join('config', 'config.yml'), symbolize_names: true, aliases: true) || {}
  end

  def projects
    @projects ||= config.fetch(:projects, [])
  end

  def behaviours
    @behaviours ||= config.fetch(:behaviours, {})
  end

  def misc
    @misc ||= config.fetch(:misc, {})
  end

  def languages
    @languages ||= config.fetch(:languages, {})
  end

  def options=(value)
    @options ||= value
  end

  def options
    @options ||= {}
  end
end
