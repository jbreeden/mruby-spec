module Conf
  class << self
    attr_accessor :output_dir
  end
  
  def self.output_dir
    @output_dir || ENV['output'] || 'gh-pages'
  end
  
  def self.output_given?
    !(ENV['output'].nil?)
  end
  
  def self.valgrind?
    self.valgrind_given? && ENV['valgrind'].downcase == 'true'
  end
  
  def self.valgrind_given?
    !(ENV['valgrind'].nil?)
  end
end

desc "Same as 'rake clean language core index output=./gh-pages'"
task :default => [:clean, :language, :core, :index]

desc 'Clean the output directory'
task :clean do
  clean
end

desc "Run this once to initialize your clone of the project"
task :"init" do
  unless Dir.exists?('rubyspec')
    sh "git clone https://github.com/jbreeden/spec rubyspec"
    cd "rubyspec" do
      sh "git checkout mruby"
    end
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
