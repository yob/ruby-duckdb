gem "mini_portile2", "~> 2.8.2"

require 'mkmf'
require "mini_portile2"

def duckdb_library_available?(func)
  header = find_header('duckdb.h') || find_header('duckdb.h', '/opt/homebrew/include')
  library = have_func(func, 'duckdb.h') || find_library('duckdb', func, '/opt/homebrew/opt/duckdb/lib')
  header && library
end

def check_duckdb_library(func, version)
  return if duckdb_library_available?(func)

  msg = "duckdb >= #{version} is not found. Install duckdb >= #{version} library and header file."
  puts ''
  puts '*' * 80
  puts msg
  puts '*' * 80
  puts ''
  raise msg
end

package_root_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

port_path = nil
MiniPortileCMake.new("duckdb", "0.8.0").tap do |recipe|
  recipe.files = [{
    url: "https://github.com/duckdb/duckdb/archive/refs/tags/v0.8.0.tar.gz",
    sha256: "df3b8e0b72bce38914f0fb1cd02235d8b616df9209beb14beb06bfbcaaf2e97f",
  }]

  recipe.target = File.join(package_root_dir, "ports")
  unless File.exist?(File.join(recipe.target, recipe.host, recipe.name, recipe.version))
    recipe.cook
  end
  recipe.activate
  #pkg_config(File.join(recipe.path, "lib", "pkgconfig", "yaml-0.1.pc"))
  port_path = recipe.path
end
dir_config('duckdb', File.join(port_path, "include"), File.join(port_path, "lib"))

check_duckdb_library('duckdb_pending_prepared', '0.5.0')

# check duckdb >= 0.6.0
have_func('duckdb_value_string', 'duckdb.h')

# check duckdb >= 0.7.0
have_func('duckdb_extract_statements', 'duckdb.h')

create_makefile('duckdb/duckdb_native')
