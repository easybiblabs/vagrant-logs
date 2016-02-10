module VagrantPlugins
  module CommandLogs
    class Command < Vagrant.plugin('2', :command)
      def self.synopsis
        'Print some logs'
      end

      def execute
        result = {}

        with_target_vms(@argv, single_target: true) do |vm|
          prepare_log_file_names(vm)
          result[:log_files] = fetch_log_files(vm)

          result[:repository_revisions] = fetch_repository_revisions(vm)

          result[:client_versions] = fetch_client_versions(vm)
        end


        print_result(result)

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
            # TODO Handle errors
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
          # TODO Handle errors
          vm.communicate.sudo("tail -#{vm.config.vagrant_logs.lines} #{log_file}") do |type, data|
            if type == :stdout
              result[log_file] = data.split(/[\r\n]+/)
            end
          end
        end

        result
      end

      def print_result(result)
        print_repository_revisions(result[:repository_revisions])
        print_log_files_result(result[:log_files])
        print_client_versions(result[:client_versions])
      end

      def print_client_versions(client_versions)
        puts "Client versions\n"
        puts "--------------------\n"

        client_versions.each do |client, version|
          puts "#{client}: #{version}\n"
        end
      end

      def fetch_client_versions(vm)
        result = {}

        vm.config.vagrant_logs.clients_to_check.each do |client|
          # TODO Handle errors
          result[client] = `#{client} -v`
        end

        result
      end

      def print_repository_revisions(repository_revisions)
        puts "Repository revisions\n"
        puts "--------------------\n"

        repository_revisions.each do |repository, revision|
          puts "#{repository}: #{revision}\n"
        end
      end

      def print_log_files_result(log_files_results)
        puts "Log files\n"
        puts "---------\n"

        if log_files_results.nil?
          puts "Sorry, no log files fetched.\n"
        else
          log_files_results.each do |filename, log_file_results|
            puts "#{filename}\n"
            log_file_results.each do |result|
              puts "#{result}\n"
            end
            puts "\n\n\n"
          end
        end
      end

      def fetch_repository_revisions(vm)
        result = {}

        vm.config.vagrant_logs.repositories_to_check.each do |repository|
          # TODO Handle errors
          result[repository] = `(cd #{repository} && git rev-parse HEAD)`
        end

        result
      end
    end
  end
end
