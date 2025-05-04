# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  enable_coverage :branch
  add_filter 'spec/'
  add_filter 'config/'
  add_filter 'node_modules/'
  add_filter 'tmp'
  add_filter 'app/helpers'
  add_filter 'app/jobs'
  add_filter 'app/mailers'
  add_filter 'app/channels'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Serializers', 'app/serializers'
  add_group 'Services', 'app/services'

  minimum_coverage 95
end
