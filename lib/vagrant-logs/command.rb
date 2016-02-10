module VagrantPlugins
  module CommandLogs
    class Command < ::Vagrant.plugin('2', :command)
      def self.synopsis
        'Print some logs'
      end

      def execute
        with_target_vms(@argv, single_target: true) do |vm|
          result = {}

          prepare_log_file_names(vm)

          result[:log_files] = fetch_log_files(vm)

          print_result(result)
        end

        return 0
      end


      protected

      def prepare_log_file_names(vm)
        vm.config.vagrant_logs.log_files = expand_log_file_names(vm.config.vagrant_logs.log_files, vm)
      end

      def expand_log_file_names(log_files, vm)
        expanded_file_names = []

        log_files.delete_if do |log_file|
          if log_file.include?('*')
            vm.communicate.sudo("ls -1 #{log_file}") do |type, data|
              if type == :stdout
                expanded_file_names << data.split(/[\r\n]+/)
              end
            end

            true
          end
        end

        (log_files + expanded_file_names).flatten
      end

      def fetch_log_files(vm)
        result = {}

        vm.config.vagrant_logs.log_files.each do |log_file|
          vm.communicate.sudo("tail -#{vm.config.vagrant_logs.lines} #{log_file}") do |type, data|
            if type == :stdout
              result[log_file] = data.split(/[\r\n]+/)
            end
          end
        end

        result
      end

      def print_result(result)
        print_log_files_result(result[:log_files])
      end

      def print_log_files_result(log_files_results)
        puts "Log files\n"
        puts "---------\n"

        log_files_results.each do |filename, log_file_results|
          puts "#{filename}\n"
          log_file_results.each do |result|
            puts "#{result}\n"
          end
          puts "\n\n\n"
        end
      end
    end
  end
end
