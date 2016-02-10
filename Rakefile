require 'coveralls'
Coveralls.wear!

## Bundler::GemHelper.install_tasks

require 'bundler/gem_tasks'
require 'minitest/autorun'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

task :test do
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/*_test.rb') do |f|
    require f
  end
end
