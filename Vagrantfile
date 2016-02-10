Vagrant.configure('2') do |config|
  # for testing ubuntu 14.04
  config.vm.box = 'trusty-server-cloudimg-amd64-vagrant-disk1.box'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'

  config.vagrant_logs.log_files = ['/var/log/*log']
  config.vagrant_logs.lines = 5
  config.vagrant_logs.repositories_to_check = ['~/Sites/easybib/cookbooks', '~/projects/ies/vagrant-logs']
end
