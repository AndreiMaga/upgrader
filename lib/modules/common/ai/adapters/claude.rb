# frozen_string_literal: true

module Upgrader
  module Modules
    module Common
      module Ai
        module Adapters
          class Claude
            def initialize(model: nil)
              @model = model || ::Config.ai[:model]
              raise 'No model configured for ai adapter. Set ai.model in config.yml' unless @model
            end

            def ask(prompt)
              escaped_prompt = prompt.gsub("'", "'\\''")
              `claude -p '#{escaped_prompt}' --model #{@model} --allowed-tools WebSearch 2>&1`
            end
          end
        end
      end
    end
  end
end
