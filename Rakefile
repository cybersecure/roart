#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '-c -f progress'
end

task :default => 'spec'
