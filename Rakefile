require 'rubygems'
require 'English'
require 'bundler/setup'
require 'rubocop/rake_task'
require 'cane/rake_task'
require 'rspec/core/rake_task'
require 'foodcritic'
require 'kitchen/rake_tasks'
require 'stove/rake_task'

desc 'Run Cane to check code quality metrics'
Cane::RakeTask.new

desc 'Run RuboCop to lint check Ruby code'
RuboCop::RakeTask.new

desc 'Display LOC stats'
task :loc do
  puts "\n## LOC Stats"
  sh 'countloc -r .'
end

desc 'Run knife cookbook syntax test'
task :cookbook_test do
  path = File.expand_path('../..', __FILE__)
  cb = File.basename(File.expand_path('..', __FILE__))
  Kernel.system "knife cookbook test -c test/knife.rb -o #{path} #{cb}"
  $CHILD_STATUS == 0 || fail('Cookbook syntax check failed!')
end

desc 'Run Foodcritic lint tests'
FoodCritic::Rake::LintTask.new do |f|
  f.options = { fail_tags: %w(any) }
end

desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = ['test/**{,/*/**}/*_spec.rb']
end

desc 'Run a full converge test'
task :converge do
  fail 'Convergence tests not yet implemented'
end

task default: %w(cane rubocop loc cookbook_test foodcritic spec)

# vim: ai et ts=2 sts=2 sw=2 ft=ruby fdm=marker
