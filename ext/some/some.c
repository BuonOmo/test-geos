// #define GEOS_USE_ONLY_R_API 1

#include "ruby.h"

VALUE
c_voronoi(int argc, VALUE *argv, VALUE self)
{
	ID table[3];
	table[0] = rb_intern("env");
	table[1] = rb_intern("tolerance");
	table[2] = rb_intern("only_edges");

	VALUE kwargs;
	VALUE values[3];

	VALUE env;
	VALUE tolerance;
	VALUE only_edges;

	rb_scan_args(argc, argv, ":", &kwargs);
	rb_get_kwargs(kwargs, table, 0, 3, values);

	env = values[0] == Qundef ? Qnil : values[0];
	tolerance = values[1] == Qundef ? Qnil : values[1];
	only_edges = values[2] == Qundef ? Qfalse : values[2];

	// actual voronoi code

	return Qnil;
}

VALUE
__ruby_voronoi(VALUE self, VALUE env, VALUE tolerance, VALUE only_edges)
{
	// See lib/some.rb for the arg parsing

	// actual voronoi code
	return Qnil;
}

#include <Ruby/ruby.h>

void Init_some() {
	VALUE mod = rb_define_module("Some");
	rb_define_singleton_method(mod, "c_voronoi", c_voronoi, -1);
	rb_define_singleton_method(mod, "__ruby_voronoi", __ruby_voronoi, 3);
}
