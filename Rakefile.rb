require 'timeout'

def run_test_file(f)
  raise "File path should start with rubyspec/..." unless f.start_with?('rubyspec/')
  
  results = f.sub('rubyspec', 'gh-pages/results').sub('.rb', '.html')
  results_dir = File.dirname(results)
  mkdir_p(results_dir) unless Dir.exist?(results_dir)
  File.open("#{results}.meta", 'w') { } # empty the file
  
  pid = nil
  Timeout.timeout(60) do
    pid = spawn "mspec/bin/mspec --format html -t mruby #{f} > #{results} 2> #{results}.stderr.txt"
    Process.wait(pid)
    File.open("#{results}.meta", 'w') { |f| 
      if $?.exitstatus == 0
        f.puts "Success"
      elsif $?.exitstatus == 1
        f.puts "Failed"
      else
        f.puts "Crashed"
      end
    }
  end
rescue TimeoutError
  $stderr.puts "!!! Killing #{pid} !!! Test timed out: #{f}"
  Process.kill(:SIGINT, pid)
  File.open("#{results}.meta", 'w') { |f| f.puts "Timed out" }
end

desc "Clone or update ./rubyspec and ./mspec"
task :init do
  unless Dir.exists?('rubyspec')
    sh "git clone https://github.com/ruby/spec rubyspec"
  end
  
  unless Dir.exists?('mspec')
    sh "git clone https://github.com/jbreeden/mspec mspec"
    cd "mspec" do
      sh "git checkout mruby"
    end
  end
  
  unless Dir.exists?('gh-pages')
    mkdir 'gh-pages'
    cd 'gh-pages' do
      sh "git clone .. ."
      sh "git checkout gh-pages"
    end
  end
end

task :core do
  %w[
    .argf
    array
    basicobject
    .bignum
    .binding
    builtin_constants
    class
    comparable
    .complex
    dir
    .encoding
    enumerable
    enumerator
    .env
    exception
    false
    fiber
    .file
    .filetest
    fixnum
    float
    .gc
    hash
    integer
    .io
    kernel
    main
    .marshal
    .matchdata
    math
    .method
    module
    .mutex
    nil
    numeric
    objectspace
    proc
    .process
    random
    range
    .rational
    .regexp
    .signal
    string
    struct
    symbol
    .systemexit
    .thread
    .threadgroup
    time
    true
    .unboundmethod
  ].each do |dir|    
    next if dir.start_with?('.')
    
    Dir["rubyspec/core/#{dir}/*.rb"].each do |f|
      run_test_file(f)
    end
  end
end

task :language do
  Dir['rubyspec/language/*.rb'].each do |f|
    run_test_file(f)
  end
end

task :clean do
  rm_rf './gh-pages/results' if Dir.exist?('gh-pages/results')
end

# Re-generate the index.html file for the results
task :index do
  require 'erb'
  
  cols = %w[File Examples Expectations Failures Errors Outcome]
  test_files = {}
  totals = Hash.new { |h, k| h[k] = 0 }
  
  Dir['gh-pages/results/**/*.html'].each do |filename|
    f = File.open(filename, 'r')
    test_files[filename] = {}
    
    f.each_line do |line|
      if match = line.match(/(?<file>\d+)\s*file(s?),\s*(?<examples>\d+)\s*example(s?),\s*(?<expectations>\d+)\s*expectation(s?),\s*(?<failures>\d+)\s*failure(s?),\s*(?<errors>\d+)\s*error(s?),\s*(?<tagged>\d+)\s*tagged(s?)/)
        test_files[filename][:examples] = match[:examples]
        totals[:examples] += match[:examples].to_i
        test_files[filename][:expectations] = match[:expectations]
        totals[:expectations] += match[:expectations].to_i
        test_files[filename][:failures] = match[:failures]
        totals[:failures] += match[:failures].to_i
        test_files[filename][:errors] = match[:errors]
        totals[:errors] += match[:errors].to_i
      end
    end
    test_files[filename][:outcome] = File.read("#{filename}.meta").strip
  end
  
  erb = ERB.new(File.read('index.html.erb'), nil, '-')
  File.open('gh-pages/index.html', 'w') { |f| f.write(erb.result(binding)) }
end

desc "Run the tests"
task :default => [:clean, :language, :core, :index]
