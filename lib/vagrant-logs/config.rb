module VagrantPlugins
  module CommandLogs
    class Config < Vagrant.plugin('2', :config)
      attr_accessor :log_files
      attr_accessor :lines

      def initialize
        @log_files = UNSET_VALUE
        @lines = UNSET_VALUE
      end

      def finalize!
        @log_files = [] if @log_files == UNSET_VALUE
        @lines = 50 if @lines == UNSET_VALUE
      end
    end
  end
end
