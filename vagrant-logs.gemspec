lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'vagrant-logs/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-logs'
  spec.version       = VagrantPlugins::CommandLogs::VERSION
  spec.platform		   = Gem::Platform::RUBY
  spec.authors       = %w('seppsepp', 'fh')
  spec.email         = ['sebastian.lenk@gmail.com']
  spec.description   = 'A RubyGem to print log files and/or upload them to a Gist'
  spec.summary       = 'Print log files and/or upload to Gist'
  spec.homepage      = 'https://github.com/easybiblabs/vagrant-logs'
  spec.license       = 'New BSD License'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'gist'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.0.8'
  spec.add_development_dependency 'coveralls'
end
