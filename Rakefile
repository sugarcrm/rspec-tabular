# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'bundler/audit/task'
require 'pathname'
require 'license_finder'
require 'English'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = '--warnings'
end

RuboCop::RakeTask.new(:rubocop) do |task|
  rubocop_report_pathname =
    Pathname(Rake.application.original_dir).join('tmp', 'rubocop.txt')
  rubocop_report_pathname.dirname.mkpath
  task.requires << 'rubocop-rspec'
  task.options =
    %w[
      --display-cop-names
      --extra-details
      --display-style-guide
      --fail-level error
      --format progress
      --format simple --out
    ].push(rubocop_report_pathname.to_s)
end

Bundler::Audit::Task.new

desc 'Check dependency licenses'
task :license_finder do
  puts `license_finder --quiet --format text`

  abort('LicenseFinder failed') unless $CHILD_STATUS.success?
end

desc 'Show which specified gems are outdated'
task 'bundle:outdated' do
  bundle_outdated_report_pathname =
    Pathname(Rake.application.original_dir).join('tmp', 'bundle_outdated.txt')
  bundle_outdated_report_pathname.dirname.mkpath

  # TODO: Should consider re-writing this without using `tee`.
  sh("bundle outdated --only-explicit | tee #{bundle_outdated_report_pathname}")
end

task default: %i[spec rubocop bundle:audit license_finder]
