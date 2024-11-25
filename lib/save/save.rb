# frozen_string_literal: true

module Upgrader
  module Save
    module_function

    def save_file
      File.join('saves', "#{Time.now.strftime('%Y%m%d')}_save.yml")
    end

    def projects
      @projects ||= {}
    end

    def register_project(project)
      projects[project.name] = project
    end

    def build_opts(name, opts)
      return @config[name]&.merge(opts) if @config.key?(name)

      opts
    end

    def config
      return @config if @config

      @config = if File.exist?(save_file)
                  YAML.load_file(save_file, symbolize_names: true, aliases: true) || {}
                else
                  {}
                end
      cleanup_saves # clean after loading the current save
    end

    def cleanup_saves
      Dir['saves/*'].each do |file|
        next if file.end_with?('.keep')

        File.delete(file)
      end
    end

    def load!
      config
    end

    def save!
      clean_projects = projects.reject { |_, p| p.skip } || {}
      build_projects = clean_projects.transform_values do |project|
        { finished_steps: project.finished_steps }
      end

      File.open(save_file, 'w') do |file|
        file.write(build_projects.to_yaml)
      end
    end
  end
end
