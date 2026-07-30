# frozen_string_literal: true

desc "Build the site"
task :build do
  sh "bundle exec jekyll build --trace"
end

desc "Serve the site with live reload"
task :serve do
  sh "bundle exec jekyll serve --host 0.0.0.0 --livereload --trace"
end

desc "Everything CI runs"
task ci: [:build]

task default: [:build]
