action :signal do
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

  req = ::Net::HTTP::Put.new(new_resource.url)
  req.content_type = ""
  

  req.body = JsonCompat.to_json({"Status" => status, "UniqueId" => unique_id, "Reason" => new_resource.reason, "Data" => new_resource.data})
  begin
    Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
  rescue Exception => e
    Chef::Log.warn "Failed to signal CloudFormation, reason: #{e.inspect}"
    raise e
  end
  new_resource.updated_by_last_action true
end
