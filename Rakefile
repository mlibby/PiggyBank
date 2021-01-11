require 'rake/testtask'

task default: :test

Rake::TestTask.new do |t|
  t.libs << "src/test"
  t.test_files = FileList["src/test/**/test_*.rb"]
end