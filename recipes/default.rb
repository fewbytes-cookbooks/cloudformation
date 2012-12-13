# when ohai 6.16 will arive it will support iam roles, in that case it may be wise to ditch aws-sdk in favor of right_aws
# because it doesn't require nokogiri
include_recipe "xml::ruby"
chef_gem "aws-sdk"

include_recipe 'ohai'
