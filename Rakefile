require 'bundler'
Bundler::GemHelper.install_tasks

desc "run all specs"
task :spec do
 system "bundle exec rspec spec"
end

desc "run all cucumber features"
task :features do
  system "bundle exec cucumber features"
end

namespace :spec do
  # more spec running tasks here
  # whenever
end

task :default => [:features, :spec]
