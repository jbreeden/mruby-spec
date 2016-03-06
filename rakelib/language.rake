desc 'Run tests for language features [output=./output/mruby]'
task :language do
  unless Conf.output_given?
    Conf.output_dir = 'output/mruby'
  end
  Dir['rubyspec/language/*.rb'].each do |f|
    run_test_file(f)
  end
end
