# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/saves/'
  add_filter '/config/'

  add_group 'Common Modules', 'lib/modules/common'
  add_group 'Ruby Modules', 'lib/modules/ruby'
end

SimpleCov.coverage_dir 'coverage'

require 'init/boot'
