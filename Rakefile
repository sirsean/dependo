require 'rubygems'
require 'rspec/core/rake_task'
require "#{File.dirname(__FILE__)}/lib/dependo"

task :default => :spec
RSpec::Core::RakeTask.new(:spec)

desc 'Run all rspec tests with rcov (1.8 only)'
RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov_opts =  %q[--exclude "spec,gems"]
    t.rcov = true
end

namespace :gem do
    task :build do
        puts `yard`
        puts `gem build dependo.gemspec`
    end

    task :install do
        puts `gem install dependo-#{Dependo::VERSION}.gem`
    end

    task :uninstall do
        puts `gem uninstall dependo`
    end
end

desc 'Build yard documentation'
task :yard do
    puts `yard`
    `open doc/index.html`
end
