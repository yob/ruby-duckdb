require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rake/extensiontask"

task :build => :compile

GEMSPEC = Gem::Specification.load("duckdb.gemspec")

# add your default gem packing task
Gem::PackageTask.new(GEMSPEC) do |pkg|
end

Rake::ExtensionTask.new("duckdb_native", GEMSPEC) do |ext|
  ext.ext_dir = 'ext/duckdb'
  ext.lib_dir = "lib/duckdb"
end

task :default => [:clobber, :compile, :test]
