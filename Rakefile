require 'foodcritic'
require 'foodcritic/rake_task'
require 'rubocop/rake_task'

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['**/*.rb']
  # only show the files with failures
  task.formatters = ['files']
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
      '~FC046'
    ]
  }
end

desc 'Run all tests'
task :test => [:lint, :rubocop]
task :default => :test
