require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :headers do
  require 'rubygems'
  require 'copyright_header'

  spec = Gem::Specification.load 'backlog_reporter.gemspec'

  args = {
    license: spec.license,
    copyright_software: spec.name,
    copyright_software_description: spec.summary,
    :copyright_holders => ['Conjur Inc.'],
    :copyright_years => ['2016'],
    :add_path => 'lib:spec',
    :output_dir => '.'
  }

  command_line = CopyrightHeader::CommandLine.new( args )
  command_line.execute
end

begin
  require 'ci/reporter/rake/rspec'

  task jenkins: ['ci:setup:rspec', :spec]
rescue LoadError
  # expected on non-jenkins
end
