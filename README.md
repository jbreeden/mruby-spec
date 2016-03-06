MRUBY SPEC
==========

This project provides a Rakefile for running selected tests from RubySpec against
[mruby](https://github.com/mruby/mruby) & [mruby-apr](https://github.com/jbreeden/mruby-apr).

[You can find the latest test results here.](https://googledrive.com/host/0B0NNQZ6fVYyieGJXY3FGSWxWQmM/)

Usage
-------

1. Clone this repo `git clone https://github.com/jbreeden/mruby-spec`
2. `rake init` to checkout `ruby/spec` and a `ruby/mspec` clone customized for MRuby.
3. `rake` to run the selected tests. Test results are collected as a gh-pages branch
   by default (they'll show up under `./gh-pages`).
   
The available rake tasks are:

```
[jared:~/projects/mruby-spec] rake -T
rake apr       # Run tests for mruby-apr features [output=./output/apr]
rake clean     # Clean the output directory
rake core      # Run tests for core features [output=./gh-pages]
rake default   # Same as 'rake clean language core index output=./gh-pages'
rake index     # Generate the index.html file for the results [output=./gh-pages]
rake init      # Run this once to initialize your clone of the project
rake language  # Run tests for language features [output=./gh-pages]
rake regexp    # Run tests for Regexp features [output=./output/regexp]
```

The default `output` parameter for each task is shown above, and all may be overridden.

To invoke tests with valgrind enabled, pass `valgrind=true` to the rake task.

```
# Run regexp tests under valgrind, and generate the index file.
rake output=my_output_dir valgrind=true regexp index
```

Requirements
------------

1. An mruby build with the [mruby-apr](https://github.com/jbreeden/mruby-apr) gem
   included.
2. The `mruby` executable must be on your path.
