desc 'Run tests for core features [output=./gh-pages]'
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
    .dir
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
