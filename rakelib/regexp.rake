desc 'Run tests for Regexp features [output=./output/regexp]'
task :regexp do
  unless Conf.output_given?
    Conf.output_dir = 'output/regexp'
  end
  clean
  Dir["rubyspec/language/{regexp,match}_spec.rb"].each do |f|
    run_test_file(f)
  end
  compile_index
end
