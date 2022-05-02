# Steps:
# 1. git clone
# 2. mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release ..
# 3. make
# 4. reference the lib

require "mkmf"
require "net/http"
require "rubygems/package"
require "zlib"

GEOS_VERSION = "3.9.2"


def build_geos_dir(url, path)
  return if Dir.exist? path
  uri = URI(url)
  file = Tempfile.new

  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
    http.request_get(uri) do |resp|
      resp.read_body(file)
    end
  end
  file.rewind

  geos_tar = Gem::Package::TarReader.new(Zlib::GzipReader.new(file))

  FileUtils.mkdir_p(path)
  Dir.chdir(path) do
    geos_tar.each do |entry|
      if entry.directory?
        FileUtils.mkdir_p entry.full_name
      elsif entry.file? && !File.exist?(entry.full_name)
        IO.write(entry.full_name, entry.read)
      end
    end
  end

ensure
  geos_tar&.close
  file&.close
  file&.unlink
end



dir = nil
build_geos_dir("https://codeload.github.com/libgeos/geos/tar.gz/refs/tags/#{GEOS_VERSION}", "geos")
FileUtils.mkdir_p "geos/geos-3.9.2/build"
Dir.chdir("geos/geos-3.9.2/build") do
  system("cmake", "-DCMAKE_BUILD_TYPE=Release", "..")
  system("make")
end
lib_path = File.expand_path("geos/geos-3.9.2/build/lib", Dir.pwd)
geos_inc_path = File.expand_path("geos/geos-3.9.2/include", Dir.pwd)
inc_path = File.expand_path("geos/geos-3.9.2/build/capi", Dir.pwd)

$LIBPATH = [lib_path]
find_library("geos_c", nil, lib_path) # TODO: can we force the level at that stage ? (seems like this is not that simple, geos_c version is not geos version..)

# https://stackoverflow.com/a/53132272/6320039
$LDFLAGS << " -Wl,-rpath,#{lib_path.inspect}"

# raise "no geos_c.h" unless have_header("geos_c.h")
create_makefile("some/some")
