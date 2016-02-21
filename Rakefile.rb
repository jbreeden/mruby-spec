require 'timeout'

module Conf
  class << self
    attr_accessor :output_dir
  end
  
  def self.output_dir
    @output_dir || ENV['o'] || ENV['output'] || 'gh-pages'
  end
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

task :clean do
  clean
end

desc "Run the tests"
task :default => [:clean, :language, :core, :index]
