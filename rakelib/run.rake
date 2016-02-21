desc "Run all tests in a file or directory (`rake run tests=path/to/tests`)"
task :run do
  unless ENV['tests']
    $stderr.puts "Must specify tests argument"
    exit 1
  end
  
  pick = ENV['tests']
  if FileTest.file?(pick)
    run_test_file(pick)
  else
    puts pick
    Dir["#{pick}/*.rb"].each do |f|
      run_test_file(f)
    end
  end
end
