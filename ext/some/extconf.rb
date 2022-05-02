# Steps:
# 1. git clone
# 2. mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release ..
# 3. make
# 4. reference the lib

require "mkmf"
require "net/http"
require "zlib"

GEOS_VERSION = "3.9.2"

system("git", "clone", "--depth", "1", "--branch", GEOS_VERSION, "https://github.com/libgeos/geos") # TODO: rather than git clone, download the tar file?
FileUtils.mkdir_p "geos/build"
Dir.chdir("geos/build") do
  system("cmake", "-DCMAKE_BUILD_TYPE=Release", "..")
  system("make")
end
lib_path = File.expand_path("geos/build/lib", Dir.pwd)
geos_inc_path = File.expand_path("geos/include", Dir.pwd)
inc_path = File.expand_path("geos/build/capi", Dir.pwd)

$LIBPATH = [lib_path]
find_library("geos_c", nil, lib_path) # TODO: can we force the level at that stage ? (seems like this is not that simple, geos_c version is not geos version..)

# https://stackoverflow.com/a/53132272/6320039
$LDFLAGS << " -Wl,-rpath,#{lib_path.inspect}"

# raise "no geos_c.h" unless have_header("geos_c.h")

create_makefile("some/some")




require "net/http"
require "zlib"
GEOS_VERSION = "3.9.2"

uri = URI("https://codeload.github.com/libgeos/geos/tar.gz/refs/tags/#{GEOS_VERSION}")
puts uri.to_s
Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
  http.request_get(uri) do |resp|
    File.open("geos.tar.gz", "w") do |io|
      resp.read_body(io)
    end
  end
end
