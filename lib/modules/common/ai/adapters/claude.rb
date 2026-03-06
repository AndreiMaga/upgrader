# frozen_string_literal: true

module Upgrader
  module Modules
    module Common
      module Ai
        module Adapters
          class Claude
            def initialize(model: nil, project_path: nil)
              @model = model || ::Config.ai[:model]
              @project_path = project_path
              raise 'No model configured for ai adapter. Set ai.model in config.yml' unless @model
            end

            def ask(prompt)
              escaped_prompt = prompt.gsub("'", "'\\''")
              cmd = "claude -p '#{escaped_prompt}' --model #{@model} --allowed-tools WebSearch"
              cmd += " --add-dir #{@project_path}" if @project_path
              `#{cmd} 2>&1`
            end
          end
        end
      end
    end
  end
end
