task :regexp do
  Conf.output_dir = 'output/regexp'
  clean
  Dir["rubyspec/language/{regexp,match}_spec.rb"].each do |f|
    run_test_file(f)
  end
  compile_index
end
