module VagrantPlugins
  module CommandLogs
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :log_files
      attr_accessor :lines
      attr_accessor :repositories_to_check

      def initialize
        @log_files = UNSET_VALUE
        @lines = UNSET_VALUE
        @repositories_to_check = UNSET_VALUE
      end

      def finalize!
        if @log_files == UNSET_VALUE
          @log_files = %w(/var/log/syslog /var/log/nginx/*log /var/log/php/*log .vagrant.d/data/landrush/log)
        end

        @lines = 50 if @lines == UNSET_VALUE
        @repositories_to_check = [] if @repositories_to_check == UNSET_VALUE
      end
    end
  end
end
