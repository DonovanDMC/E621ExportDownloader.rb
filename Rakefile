# frozen_string_literal: true

require("bundler/gem_tasks")
require("rake/testtask")
require("rubocop/rake_task")

Rake::TestTask.new(:test) do |t|
  t.pattern = "test/**/*_test.rb"
end

namespace(:test) do
  desc("Test Zeitwerk Auto-Importing")
  task(:zeitwerk) do
    exec(%(bundle exec ruby -e "require 'e621_export_downloader'; Zeitwerk::Loader.eager_load_all"))
  end
end

task(default: :rubocop)
