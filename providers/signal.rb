require 'uri'
action :signal do
  if new_resource.once and node["cloudformation"]["sent_signals"].include? new_resource.url
    Chef::Log.info "Not signaling because CloudFormation signal #{new_resource.name} has alredy been sent and `once` is true"
    return
  end
  status = if new_resource.success
             "SUCCESS"
           else
             "FAILURE"
           end
  unique_id = if new_resource.unique_id.is_a? Proc
                new_resource.unique_id.call
              else
                new_resource.unique_id.to_s
              end

  url = if new_resource.url.is_a? URI
          new_resource.url
        else
          URI.parse(new_resource.url)
        end
  req = ::Net::HTTP::Put.new(url.request_uri)
  req.content_type = ""
  
  req.body = JsonCompat.to_json({"Status" => status, "UniqueId" => unique_id, "Reason" => new_resource.reason, "Data" => new_resource.data})
  begin
    Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    if new_resource.once
      node.default["cloudformation"]["sent_signals"] << new_resource.url
    end
    new_resource.updated_by_last_action true
  rescue Exception => e
    Chef::Log.warn "Failed to signal CloudFormation, reason: #{e.inspect}"
    raise e
  end
end
