require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'tests/ruby/**/*_spec.rb'
  t.rspec_opts = '--require ./tests/ruby/spec_helper'
end

task default: :spec

desc "Run all Ruby tests"
task :test => :spec