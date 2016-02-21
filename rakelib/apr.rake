desc 'Run tests for mruby-apr features [output=./output/apr]'
task :apr do
  unless Conf.output_given?
    Conf.output_dir = 'output/apr'
  end
  
  %w[
    builtin_constants
    dir
    env
    file
    filetest
    io
    kernel
    process
  ].each do |dir|    
    Dir["rubyspec/core/#{dir}/*.rb"].each do |f|
      run_test_file(f)
    end
  end
  
  %w[
    observer
    openstruct
    pathname
    pp
    shellwords
    socket
    tmpdir
  ].each do |dir|    
    Dir["rubyspec/library/#{dir}/*.rb"].each do |f|
      run_test_file(f)
    end
  end
end
