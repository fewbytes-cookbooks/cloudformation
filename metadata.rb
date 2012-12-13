name             "cloudformation"
maintainer       "Fewbytes"
maintainer_email "avishai@fewbytes.com"
license          "Apache V2"
description      "Tools for integrating Chef with CloudFormation"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends          "chef_handler"
depends          "ohai"
depends          "xml", "~> 1.1.0"
