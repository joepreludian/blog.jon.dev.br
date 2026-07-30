# frozen_string_literal: true

require "rake/testtask"

desc "Build the site"
task :build do
  sh "bundle exec jekyll build --trace"
end

desc "Serve the site with live reload"
task :serve do
  sh "bundle exec jekyll serve --host 0.0.0.0 --livereload --trace"
end

desc "Run RuboCop"
task :lint do
  sh "bundle exec rubocop"
end

Rake::TestTask.new(:test) do |t|
  t.description = "Run the Minitest suite"
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

desc "Validate the built site with html-proofer"
task :proof do
  external = ENV.fetch("PROOF_EXTERNAL", "0") == "1"
  flags = external ? "" : "--disable-external"
  sh "bundle exec htmlproofer ./_site #{flags} --allow-hash-href --no-enforce-https"
end

desc "Everything CI runs"
task ci: %i[lint test build proof]

task default: %i[lint test]
