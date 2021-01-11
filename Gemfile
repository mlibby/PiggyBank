# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "ofx", git: "https://github.com/mlibby/ofx.git"
gem "sequel"
gem "sequel-seed"
gem "sinatra"
gem "thin"

group :dev, :test, :prod do
  gem "sqlite3"
end

group :demo do
  gem "pg"
end

group :test do
  gem "rake"
  gem "rspec"
  gem "rspec-mocks"
  gem "rack-test"
  gem "simplecov"
end
