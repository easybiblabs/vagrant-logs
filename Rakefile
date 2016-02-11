require 'rubygems'
require 'bundler/setup'

require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

# This installs the tasks that help with gem creation and
# publishing.
Bundler::GemHelper.install_tasks


task :test do
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/*_test.rb') do |f|
    require f
  end
end
