# when ohai 6.16 will arive it will support iam roles, in that case it may be wise to ditch aws-sdk in favor of right_aws
# because it doesn't require nokogiri
include_recipe "xml::ruby"
chef_gem "aws-sdk"

include_recipe 'ohai'
include_recipe 'chef_handler'
cookbook_file ::File.join(node["chef_handler"]["handler_path"], "cfn_signal.rb") do
  source "chef_handlers/cfn_signal.rb"
  mode "0644"
end
