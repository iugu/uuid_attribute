# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

def run_without_aborting(*tasks)
  errors = []

  tasks.each do |task|
    Rake::Task[task].invoke
  rescue StandardError => e
    puts task
    puts e
    errors << task
  end

  abort "Errors running #{errors.join(", ")}" if errors.any?
end

%w[mysql2 sqlite3 postgresql].each do |adapter|
  namespace :test do
    Rake::TestTask.new(adapter => "#{adapter}:env") do |t|
      t.libs << "test"
      t.libs << "lib"
      t.test_files = FileList["test/**/test_*.rb"]
    end
  end

  namespace adapter do
    desc "Adapter Tests"
    task test: adapter

    # Set the connection environment for the adapter
    desc "Env for adapter tests"
    task(:env) { ENV["TEST_ADAPTER"] = adapter }
  end

  task "test_#{adapter}" => ["#{adapter}:env", "test:#{adapter}"]
end

desc "Default Tests"
task :test do
  tasks = %w[test_mysql2 test_sqlite3 test_postgresql]
  run_without_aborting(*tasks)
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[test rubocop]
