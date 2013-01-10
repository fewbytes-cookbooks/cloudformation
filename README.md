# Description

Tools for integrating Chef with CloudFormation.

This cookbook contains Ohai plugin that reads cloudformation metadata, LWRP and handler for coordinating with
CloudFormation WaitCondition.

# Usage

To install the handler and Ohai plugin use the cloudformation::default recipe.

## WaitCondition
The easiest way to signal wait condition on chef run completion is the cloudformation::signal recipe.
This recipe will activate the handler at the end of the Chef run. You will need to pass the Handler URL using CloudFormation resource metadata:

    "SomeAutoscalingGroup": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        ...
      },
      "Metadata": {
        "waitHandlers": {
          "chef_run_finished": {"Ref": "SomeNodeInstalledWaitHandle"}
        }
      }
    },
 
The signal recipe reads the `node['cloudformation']['metadata']['waitHandlers']['chef_run_finished']` attribute and uses it to configure the signal handler.

If you want to singal a wait condition in the middle of the chef run, e.g. after some app was deployed, you can use the `cloudformation_signal` LWRP:

    cloudformation_signal "app deployed" do
        url node['cloudformation']['metadata']['waitHandlers']['app_deployed']
        data "app deployed succefully"
    end

For other attributes of the LWRP have a look at the LWRP resource file.
