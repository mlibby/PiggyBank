require "rspec/core/rake_task"

task default: :spec

RSpec::Core::RakeTask.new(:spec) do |s|
  ENV["APP_ENV"] = "TEST"
  s.pattern = "src/spec/**/*_spec.rb"
end
