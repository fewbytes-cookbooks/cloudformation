require 'net/http'
require 'uri'
require 'chef'

module Fewbytes
  module Chef
    module Handlers
      class CloudFormationSignalHandler < ::Chef::Handler
        attr_reader :unique_id
        def initialize(opts)
          raise ArgumentError, "Arguments must be a hash with keys :url, :unique_id, :data - :url is required." \
            unless opts.is_a? Hash and opts.keys.include?(:url)
          @signal_url = opts[:url]
          @report_data = opts[:data]
          @unique_id = opts[:unique_id] || hash
          @signal_once = opts[:once] || false
        end

        def report_data
          if @report_data.is_a? Proc
            return @report_data.call
          else
            return @report_data.to_s
          end
        end

        def report
          url = URI.parse(@signal_url)
          if run_status.success? 
            status = "SUCCESS"
            data = report_data
            reason = "Chef run has completed successfully"
          else
            status = "FAILURE"
            data = run_status.formatted_exception
            reason = "Chef run has failed"
          end
          signal(url, status, reason, data)
        end

        def signal(url, status, reason, data)
          req = ::Net::HTTP::Put.new(url)
          req.content_type = ""

          req.body = JsonCompat.to_json({"Status" => status, "UniqueId" => unique_id.to_s, "Reason" => reason, "Data" => data})
          if signal_once? and run_status.node.default["cloudformation"]["sent_signals"].include? url.to_s
            Chef::Log.info "Not signaling because CloudFormation signal #{new_resource.name} has alredy been sent and `once` is true"
            return
          end
          begin
            Net::HTTP.start(url.host, url.port) do |http|
              http.request(req)
            end
          rescue Exception => e
            Chef::Log.warn "Failed to signal CloudFormation, reason: #{e.inspect}"
          end
          if signal_once?
            run_status.node.default["cloudformation"]["sent_signals"] << url.to_s
          end
        end
        
        private
        def signal_once?
          @signal_once
        end
      end
    end
  end
end
