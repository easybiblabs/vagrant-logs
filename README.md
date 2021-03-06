# VagrantLogs

[![Build Status](https://travis-ci.org/easybiblabs/vagrant-logs.png?branch=master)](https://travis-ci.org/easybiblabs/vagrant-logs)

This is subject to [additions and changes](CONTRIBUTING.md).

## Objective

 1. Print several log information ...
 2. ...and / or upload them to a Gist.

## Installation

Install the plugin:

    $ vagrant plugin install vagrant-logs

Do not use this command in a directory with a Vagrantfile which requires the plugin. Vagrant does _always_ include the Vagrantfile, and therefore will fail before installation because of the missing plugin. Just ```cd``` somewhere else and retry the command, maybe from your homedir?

## Usage

This plugin does not have any parameters - its sole use case is to output various debugging info. Sources of the debug data is specified in `Vagrantfile`, see example below.

### Standard usage
`vagrant logs` outputs all log info in the terminal.

### Gist upload

Upload to Gist can be activated by setting environment variable `GIST_UPLOAD`, e.g.:

`GIST_UPLOAD=true vagrant logs`

`GITHUB_TOKEN` must also be set as an environment variable.

### Vagrantfile

In your `Vagrantfile`:

```ruby
Vagrant.require_plugin 'vagrant-logs'

Vagrant.configure("2") do |config|
  # list of log files
  config.vagrant_logs.log_files = ['/var/log/*log']

  # number of lines to log
  config.vagrant_logs.lines = 5

  # list of locally checked out repositories for which the current revision should be logged
  # defaults to `cookbook_path` from [bib-vagrant](https://github.com/easybiblabs/bib-vagrant)
  config.vagrant_logs.repositories_to_check = ['~/Sites/easybib/cookbooks', '~/projects/ies/vagrant-logs']

  # list of locally available clients to check for their versions
  config.vagrant_logs.clients_to_check = ['vagrant', 'VBoxManage']
end
```

## Developing and Testing

Make sure you are using a Bundler version which is compatible with Vagrant which comes from GitHub like defined here:

```
group :development do
  gem 'vagrant', git: 'https://github.com/mitchellh/vagrant.git'
end
```

Bundler version 1.10.6 works fine and can be installed like this:

```
gem install bundler -v '~> 1.10.6'
```

Then, when you want to test Bib Vagrant use:

```
bundle _1.10.6_ exec vagrant
```

Happy developing and testing.

## Contributing

See [Contributing](CONTRIBUTING.md)
