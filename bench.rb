# frozen_string_literal: true

system("rake", "compile")

$LOAD_PATH.unshift("lib")
require "some"

require "benchmark/ips"

Benchmark.ips do |x|
  x.report("c arg parsing") { Some.c_voronoi }
  x.report("ruby arg parsing") { Some.ruby_voronoi }
  x.compare!
end
