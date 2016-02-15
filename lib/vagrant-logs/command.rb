require 'gist'


module VagrantPlugins
  module CommandLogs
    class Command < Vagrant.plugin('2', :command)
      def self.synopsis
        'Print some log and information (and upload them to a Gist)'
      end

      def execute
        result = {}

        with_target_vms(@argv, single_target: true) do |vm|
          prepare_log_file_names(vm)
          result[:log_files] = fetch_log_files(vm)

          result[:repository_revisions] = fetch_repository_revisions(vm)
          result[:client_versions] = fetch_client_versions(vm)
          result[:dns_resolution] = fetch_dns_resolution_check(vm)
        end

        result_as_string = result_to_string(result)

        print result_as_string

        if ENV['GIST_UPLOAD']
          upload_to_gist(result_as_string, ENV['GITHUB_TOKEN'])
        end

        return 0
      end


      protected

      def prepare_log_file_names(vm)
        vm.config.vagrant_logs.log_files = expand_log_file_names(vm.config.vagrant_logs.log_files, vm)
      end

      def expand_log_file_names(log_files, vm)
        puts "Expand files names: "

        expanded_file_names = []

        log_files.delete_if do |log_file|
          if log_file.include?('*')
            begin
              vm.communicate.sudo("ls -1 #{log_file}") do |type, data|
                case type
                when :stdout
                  expanded_file_names << data.split(/[\r\n]+/)
                when :stderr
                  puts data and exit 1
                end
              end
            rescue Vagrant::Errors::VagrantError => e
              print_sudo_exception(e)
            end

            true
          end
        end

        puts "Done\n"

        (log_files + expanded_file_names).flatten
      end

      def fetch_log_files(vm)
        puts "Fetch log files: "
        result = {}

        vm.config.vagrant_logs.log_files.each do |log_file|
          begin
            vm.communicate.sudo("tail -#{vm.config.vagrant_logs.lines} #{log_file}") do |type, data|
              case type
              when :stdout
                result[log_file] = data.split(/[\r\n]+/)
              when :stderr
                puts data and exit 1
              end
            end
          rescue Vagrant::Errors::VagrantError => e
            print_sudo_exception(e)
          end
        end

        puts "Done\n"

        result
      end

      def log_files_result_to_string(log_files_results)
        result  = "Log files\n"
        result += "---------\n"

        if log_files_results.nil?
          result += "None fetched.\n"
        else
          log_files_results.each do |filename, log_file_results|
            result += "#{filename}\n"
            log_file_results.each do |log_file_result|
              result += "#{log_file_result}\n"
            end
            result += "\n\n\n"
          end
        end

        result + "\n"
      end

      def fetch_client_versions(vm)
        result = {}

        vm.config.vagrant_logs.clients_to_check.each do |client|
          result[client] = `#{client} -v`
        end

        result
      end

      def client_versions_to_string(client_versions)
        result =  "Client versions\n"
        result += "---------------\n"

        if !client_versions.nil? and client_versions.any?
          client_versions.each do |client, version|
            result += "#{client}: #{version}\n"
          end
        else
          result += "None checked.\n"
        end

        result + "\n"
      end

      def fetch_repository_revisions(vm)
        result = {}

        vm.config.vagrant_logs.repositories_to_check.each do |repository|
          result[repository] = `(cd #{repository} && git rev-parse HEAD)`
        end

        result
      end

      def repository_revisions_to_string(repository_revisions)
        result =  "Repository revisions\n"
        result += "--------------------\n"

        if !repository_revisions.nil? and repository_revisions.any?
          repository_revisions.each do |repository, revision|
            result += "#{repository}: #{revision}\n"
          end
        else
          result += "None checked.\n"
        end

        result + "\n"
      end

      def fetch_dns_resolution_check(vm)
        puts "DNS resolution check: "

        result = ''

        begin
          vm.communicate.sudo("host -t ns google.com") do |type, data|
            case type
            when :stdout
              result = data
            when :stderr
              puts data and exit 1
            end
          end

          puts "Ok\n"
        rescue Vagrant::Errors::VagrantError => e
          print("Failed\n")
          print_sudo_exception(e)
        end

        !result.include?('no servers could be reached')
      end

      def dns_resolution_result_to_string(dns_resolution)
        result =  "DNS resolution\n"
        result += "--------------\n"

        if dns_resolution == true
          result += "Fine, works.\n"
        elsif dns_resolution == false
          result += "Doesn't seem to work.\n"
        else
          result += "Not checked.\n"
        end

        result + "\n"
      end

      def result_to_string(result)
        repository_revisions_to_string(result[:repository_revisions]) +
        client_versions_to_string(result[:client_versions]) +
        dns_resolution_result_to_string(result[:dns_resolution]) +
        log_files_result_to_string(result[:log_files])
      end

      def upload_to_gist(result, access_token)
        puts "Gist upload\n"
        puts "-----------\n"

        if access_token.nil? or access_token.empty?
          puts "Access token is missing (ENV['GITHUB_TOKEN']).\n"
        else
          gist = Gist.gist(result, filename: Time.now.to_i.to_s, access_token: access_token)

          if gist
            puts "Url: #{gist['html_url']}\n"
          else
            puts "Upload failed.\n"
          end
        end

        puts "\n"
      end

      def print_sudo_exception(exception)
        puts "Following error occured, but will be ignored:\n"
        puts exception.message
      end
    end
  end
end
