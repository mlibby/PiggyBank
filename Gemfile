# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "ofx", git: "https://github.com/mlibby/ofx.git"
gem "sequel"
gem "sequel-seed"
gem "sinatra"

group :development, :test, :production do
  gem "sqlite3"
end

group :demo do
  gem "pg"
end
