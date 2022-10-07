module Some
  VERSION = "1.0"

  def self.ruby_voronoi(env: nil, tolerance: nil, only_edges: false)
    __ruby_voronoi(env, tolerance, only_edges)
  end
end

require "some/some"
