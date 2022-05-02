https://stackoverflow.com/questions/35200405/gnu-c-how-can-i-compile-a-c-program-with-dynamic-library-option-lmylib-but-wi#35200487

```
LDSHARED = $(CC) -dynamic -bundle
```

https://stackoverflow.com/questions/21279036/what-is-clangs-equivalent-to-rdynamic-gcc-flag

https://github.com/flavorjones/mini_portile

https://github.com/brianmario/mysql2/blob/master/ext/mysql2/extconf.rb


# The ffi idea

rdkafka ruby lib is downloading a shared lib and then using it as FFI.

https://github.com/appsignal/rdkafka-ruby/blob/6a439ff07b31eb0be468b838a48855facf5f94a6/lib/rdkafka/bindings.rb#L18

# the difference between shared lib and bundle

https://github.com/kzk/jemalloc-rb/blob/864fceee6b0185b9914609ebd7bd7d412fd31d43/ext/jemalloc/extconf.rb#L42-L59


# leads

- [ ] trace the failing call to dlopen to see how to change it
- [ ] try and bundle the whole geos lib somehow
- [ ] understand what a .bundle file is


# Current solution

append the path of built stuf to rpath
