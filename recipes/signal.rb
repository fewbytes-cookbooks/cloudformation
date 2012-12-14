include_recipe "cloudformation"

if node["cloudformation"]["metadata"].has_key? "waitHandlers"
  if node["cloudformation"]["metadata"]["waitHandlers"].has_key? "chef_run_finished"
    chef_handler "Fewbytes::Chef::Handlers::CloudFormationSignalHandler" do
      source "#{node['chef_handler']['handler_path']}/cfn_signal.rb"
      arguments :url => node["cloudformation"]["metadata"]["waitHandlers"]["chef_run_finished"], :unique_id => node.name, :data => "Done running Chef"
      action :enable
    end
  end
end
