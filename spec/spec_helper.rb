# frozen_string_literal: true

require 'init/boot'

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/saves/'
  add_filter '/config/'
end

SimpleCov.coverage_dir 'coverage'
