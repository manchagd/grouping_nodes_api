# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  root = File.expand_path('../..', __dir__)
  coverage_dir File.join(root, 'coverage')

  # Explicitly set the root directory
  root root

  # Add more debugging information
  puts "SimpleCov root: #{root}"
  puts "App directory exists?: #{File.directory?(File.join(root, 'app'))}"
  puts "Models directory exists?: #{File.directory?(File.join(root, 'app', 'models'))}"
  puts "Controllers directory exists?: #{File.directory?(File.join(root, 'app', 'controllers'))}"

  add_filter %r{^/spec/}
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

# Print the current working directory and coverage directory for debugging
puts "Current working directory: #{Dir.pwd}"
puts "Coverage directory: #{SimpleCov.coverage_dir}"
