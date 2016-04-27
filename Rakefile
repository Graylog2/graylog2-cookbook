require 'foodcritic'
require 'foodcritic/rake_task'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['attributes/**/*.rb',
                   'libraries/**/*.rb',
                   'recipes/**/*.rb',
                   'spec/**/*.rb',
                   'test/integration/**/*.rb']
  # don't abort rake on failure
  task.fail_on_error = false
end

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:lint) do |t|
  t.options = {
    :fail_tags => ['any'],
    :tags => [
      '~FC001',
      '~FC009',
      '~FC015',
      '~FC019',
      '~FC046',
      '~FC053'
    ]
  }
end

# Rspec and ChefSpec
desc "Run ChefSpec examples"
  RSpec::Core::RakeTask.new(:spec)

desc 'Run all tests'
task :test => [:lint, :rubocop, :spec]
task :default => :test
