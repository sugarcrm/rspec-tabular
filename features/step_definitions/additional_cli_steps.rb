# frozen_string_literal: true

When /^I run rspec( with the documentation option)?$/ do |documentation|
  rspec_its_gem_location = File.expand_path('../../../lib/rspec/tabular', __FILE__)
  require_option = "--require #{rspec_its_gem_location}"
  format_option = documentation ? "--format documentation" : ""
  rspec_command = ['rspec', require_option, format_option, 'example_spec.rb'].join(' ')
  step "I run `#{rspec_command}`"
end
