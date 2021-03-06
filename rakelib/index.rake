desc 'Generate the index.html file for the results [output=./output/mruby]'
task :index do
  compile_index
end

def compile_index
  require 'erb'
  
  cols = %w[File Examples Expectations Failures Errors Outcome]
  test_files = {}
  totals = Hash.new { |h, k| h[k] = 0 }
  
  Dir["#{Conf.output_dir}/results/**/*.html"].sort.each do |filename|
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
    
    test_files[filename][:outcome] = File.read("#{filename.sub('.html', '.meta')}").strip
    
    if test_files[filename][:outcome].downcase == 'failed'
      # Lets be a little more granular
      if test_files[filename][:examples].to_i <= (test_files[filename][:failures].to_i + test_files[filename][:errors].to_i)
        test_files[filename][:outcome] = "Complete Failure"
      else
        test_files[filename][:outcome] = "Partial Failure"
      end
    end
  end
  
  title = ENV['title'] ? "MRuby Spec: #{ENV['title']}" : "MRuby Spec"
  
  erb = ERB.new(File.read('index.html.erb'), nil, '-')
  File.open("#{Conf.output_dir}/index.html", 'w') { |f| f.write(erb.result(binding)) }
end
