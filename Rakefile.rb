require 'timeout'

def run_test_file(f)
  raise "File path should start with rubyspec/..." unless f.start_with?('rubyspec/')
  
  results = f.sub('rubyspec', 'results').sub('.rb', '.html')
  results_dir = File.dirname(results)
  mkdir_p(results_dir) unless Dir.exist?(results_dir)
  
  pid = nil
  Timeout.timeout(20) do
    pid = spawn "mspec/bin/mspec --format html -t mruby #{f} > #{results} 2> #{results}.stderr.txt"
    Process.wait(pid)
  end
rescue TimeoutError
  $stderr.puts "!!! Killing #{pid} !!! Test timed out: #{f}"
  Process.kill(:SIGINT, pid)
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
end

desc "Run selected core tests"
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
  sh "rm -r ./results"
end

desc "Write the index file"
task :readme do
  File.open('README.md', 'w') do |readme|
    header = "|File|Examples|Expectations|Failures|Errors|"
    
    cols = header.split("|").select { |c| c && !c.empty? }.length
    
    readme.puts header
    readme.puts header.gsub(/[^|]/, '-')
    
    Dir['results/**/*.html'].each do |filename|
      f = File.open(filename, 'r')
      f.each_line do |line|
        if match = line.match(/(?<file>\d+) file, (?<examples>\d+) examples, (?<expectations>\d+) expectations, (?<failure>\d+) failure, (?<errors>\d+) errors, (?<tagged>\d+) tagged/)
          readme.puts "[#{filename.sub('results', '')}](https://rawgit.com/jbreeden/mruby-spec/master/#{filename})|#{match[:examples]}|#{match[:expectations]}|#{match[:failure]}|#{match[:errors]}"
        end
      end
    end
  end
end

task :default => [:clean, :language, :core, :readme]
