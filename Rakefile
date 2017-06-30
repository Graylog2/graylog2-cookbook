require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'

namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby) do |task|
    task.patterns = ['attributes/**/*.rb',
                     'libraries/**/*.rb',
                     'recipes/**/*.rb',
                     'spec/**/*.rb',
                     'test/integration/**/*.rb']
    # don't abort rake on failure
    task.fail_on_error = false
  end
  
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      :fail_tags => ['any'],
      :tags => [
        '~FC001',
        '~FC009',
        '~FC015',
        '~FC019',
        '~FC046',
        '~FC052',
        '~FC053'
      ]
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Rspec and ChefSpec
desc "Run ChefSpec examples"
  RSpec::Core::RakeTask.new(:spec)

desc 'Run all tests'
task :test => [:style, :spec]
task :default => :test
