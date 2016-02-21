require 'timeout'

def run_test_file(f)
  raise "File path should start with rubyspec/..." unless f.start_with?('rubyspec/')
  
  results_base = f.sub('rubyspec', "#{Conf.output_dir}/results").sub('.rb', '')
  results = results_base + '.html'
  results_dir = File.dirname(results)
  mkdir_p(results_dir) unless Dir.exist?(results_dir)
  File.open("#{results_base}.meta", 'w') { } # empty the file
  
  pid = nil
  Timeout.timeout(20) do
    cmd = "mspec/bin/mspec #{'--valgrind' if ENV['valgrind'] =~ /true/i} --format html -t mruby #{f} > #{results} 2> #{results_base}.stderr.txt"
    puts cmd
    pid = spawn cmd
    Process.wait(pid)
    File.open("#{results_base}.meta", 'w') { |f| 
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
  File.open("#{results_base}.meta", 'w') { |f| f.puts "Timed out" }
end

def clean
  if Dir.exists?(Conf.output_dir)
    Dir.entries(Conf.output_dir).each do |filename|
      relative_path = "#{Conf.output_dir}/#{filename}"
      rm_rf relative_path if File.exists?(relative_path) && !filename.start_with?('.')
    end
  else
    mkdir Conf.output_dir
  end
end
