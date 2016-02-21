def run_test_file(f)
  raise "File path should start with rubyspec/..." unless f.start_with?('rubyspec/')
  
  results = f.sub('rubyspec', "#{Conf.output_dir}/results").sub('.rb', '.html')
  results_dir = File.dirname(results)
  mkdir_p(results_dir) unless Dir.exist?(results_dir)
  File.open("#{results}.meta", 'w') { } # empty the file
  
  pid = nil
  Timeout.timeout(20) do
    cmd = "mspec/bin/mspec #{'--valgrind' if ENV['valgrind'] =~ /true/i} --format html -t mruby #{f} > #{results} 2> #{results}.stderr.txt"
    puts cmd
    pid = spawn cmd
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

def clean
  rm_rf Conf.output_dir if Dir.exist? Conf.output_dir
  mkdir Conf.output_dir
end
