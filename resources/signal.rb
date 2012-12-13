require 'uri'
actions :signal
default_action :signal

attribute :url, :kind_of => [String, URI], :required => true
attribute :unique_id, :default => proc{Random.rand(10**20)}
attribute :once, :kind_of => [FalseClass, TrueClass], :default => true
attribute :data, :kind_of => [String], :default => ""
attribute :success, :kind_of => [FalseClass, TrueClass], :default => true
attribute :reason, :kind_of => [String], :default => "Chef triggered signal from resource"


