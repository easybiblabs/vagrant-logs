source 'https://rubygems.org'

gemspec

gem 'gist'


group :development do
  gem 'vagrant', git: 'https://github.com/mitchellh/vagrant.git'
  # gem "vagrant", git: "git://github.com/mitchellh/vagrant.git", tag: "v1.7.4"
  # gem "vagrant", git: "git://github.com/mitchellh/vagrant.git", tag: "v1.3.5"

  gem 'rubocop', require: false
end

group :plugins do
  gem 'vagrant-logs', path: '.'
  gem 'bib-vagrant'
end
