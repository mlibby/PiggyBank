# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "ofx", git: "https://github.com/mlibby/ofx.git"
gem "haml"
gem "hexapdf"
gem "sequel"
gem "sequel-seed"
gem "sinatra"
gem "sinatra-flash"
gem "eventmachine", platform: "ruby"
gem "thin"

group :dev, :test, :prod do
  gem "sqlite3", platform: "ruby"
end

group :dev do
  gem "debase"
  gem "ruby-debug-ide"
  gem "rufo"
  gem "solargraph"
end

group :demo do
  gem "pg"
end

group :test do
  gem "rake"
  gem "rspec"
  gem "rspec-mocks"
  gem "rspec-html-matchers"
  gem "rack-test"
  gem "simplecov"
end
