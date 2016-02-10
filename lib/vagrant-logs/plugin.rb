module VagrantPlugins
  module CommandLogs
    class Plugin < Vagrant.plugin('2')
      name 'vagrant-logs'

      description 'Plugin allows printing logs or save them to a Gist'

      command 'logs' do
        require_relative 'command'
        Command
      end

      config 'vagrant_logs' do
        require_relative 'config'
        Config
      end
    end
  end
end
