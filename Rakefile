# -*- encoding: utf-8 -*-
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'pathname'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new(:rubocop) do |task|
  rake_application_pathname = Pathname(Rake.application.original_dir)
  rubocop_report_pathname = rake_application_pathname.join('tmp', 'rubocop.txt')
  rubocop_report_pathname.dirname.mkpath
  task.options =
    %w[--display-cop-names --extra-details --display-style-guide] +
    %w[--format progress] +
    %w[--format simple --out].push(rubocop_report_pathname.to_s)
end

task default: :spec
