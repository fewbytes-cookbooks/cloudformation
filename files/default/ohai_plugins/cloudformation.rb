require "aws-sdk"
require 'open-uri'

EC2_METADATA_URL = "http://169.254.169.254/latest/meta-data"
provides "cloudformation"

aws_region = open(EC2_METADATA_URL + "/placement/availability-zone").read[/([a-z]{2}-(?:west|east|north|south)-\d)[a-z]/,1]
instance_id = open(EC2_METADATA_URL + "/instance-id").read

cfn = AWS::CloudFormation.new(
  :cloud_formation_endpoint => "cloudformation.#{aws_region}.amazonaws.com"
  )
ec2_conn = AWS::EC2.new.regions[aws_region]
instance_tags = ec2_conn.instances[instance_id].tags
stack_name = instance_tags["aws:cloudformation:stack-name"]
resource_id = instance_tags["aws:cloudformation:logical-id"]
stack = cfn.stacks[stack_name]
resource = stack.resources[resource_id]
cloudformation Mash.new
begin
  cloudformation["metadata"] = @json_parser.parse(resource.metadata)
rescue
end
cloudformation["resource_id"] = resource.logical_resource_id
cloudformation["resource_type"] = resource.resource_type
cloudformation["stack_name"] = stack.name
cloudformation["stack_id"] = stack.id
