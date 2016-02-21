task :language do
  Dir['rubyspec/language/*.rb'].each do |f|
    run_test_file(f)
  end
end
