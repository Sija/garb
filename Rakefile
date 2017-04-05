#!/usr/bin/env rake

require 'rubygems/package_task'
require 'bundler/gem_tasks'
require 'rake/testtask'

$:.unshift File.expand_path('../lib', __FILE__)
require 'garb'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

begin
  require 'rcov/rcovtask'

  desc 'Generate RCov coverage report'
  Rcov::RcovTask.new(:rcov) do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.rcov_opts << '-x "test/*,gems/*,/Library/Ruby/*,config/*" -x lib/garb.rb -x lib/garb/version.rb --rails'
  end
rescue LoadError
  nil
end
