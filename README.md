MRUBY SPEC
==========

This project provides a Rakefile for running selected tests from RubySpec against
[mruby](https://github.com/mruby/mruby) & [mruby-apr](https://github.com/jbreeden/mruby-apr).

Usage
-------

1. Clone this repo `git clone https://github.com/jbreeden/mruby-spec`
2. `rake init` to checkout `ruby/spec` and a `ruby/mspec` clone customized for MRuby.
3. `rake` to run the selected tests. Test results are collected as a gh-pages branch
   (they'll show up under `./gh-pages`).

Requirements
------------

1. An mruby build with the [mruby-apr](https://github.com/jbreeden/mruby-apr) gem
   included.
2. The `mruby` executable must be on your path.

Latest Results
--------------

[Can be found here.](http://jbreeden.github.io/mruby-spec)
