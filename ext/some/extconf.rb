# frozen_string_literal: true

gem "mini_portile2", "~> 2.8"

require "mkmf"
require "mini_portile2"

# TODO: now take advantage of enable_config method to make this a bit customizable
# Good source of inspiration to go further:
# - https://github.com/ueno/ruby-gpgme/blob/master/ext/gpgme/extconf.rb
# - https://github.com/kwilczynski/ruby-magic/blob/main/ext/magic/extconf.rb
# - https://github.com/sparklemotion/nokogiri/blob/main/ext/nokogiri/extconf.rb

GEOS_VERSION = "3.10.2"

recipe = MiniPortileCMake.new("geos", GEOS_VERSION) # TODO: version of geos vs version of geos_c..
# codeload is one less indirection.
recipe.files = ["https://codeload.github.com/libgeos/geos/tar.gz/refs/tags/#{GEOS_VERSION}"]
recipe.cook
recipe.activate

lib_path = File.expand_path("lib", recipe.path)
inc_path = File.expand_path("include", recipe.path)
$LIBPATH = [lib_path] | $LIBPATH
# TODO: can we force the version at that stage ? (seems like this is not that simple, geos_c version is not geos version..)
$libs << " -lgeos_c"
$INCFLAGS << " -I#{inc_path}"

# # https://stackoverflow.com/a/53132272/6320039
$LDFLAGS << " -Wl,-rpath,#{lib_path.inspect}"

create_makefile("some/some")
