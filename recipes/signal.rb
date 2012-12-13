chef_handler "Fewbytes::Chef::Handlers::CloudFormationSignalHandler" do
  source "#{node['chef_handler']['handler_path']}/cfn_signal.rb"
  arguments :url => node["cloudformation"]["metadata"]["Orchestration"]["ChefHandlerSignalURL"], :unique_id => node.name, :data => "Done running Chef"
  action :enable
end
