default.demo_stack.directory = "/srv/demo_stack"
default.demo_stack.version = "1.0.0-SNAPSHOT"
default.demo_stack.user = "demo_stack"
default.demo_stack.log = "/var/log/demo_stack.log"
default.demo_stack.ports = [4000, 4001]

override.sensu.sudoers = true

override.bluepill.bin = "/usr/local/bin/bluepill"

override.haproxy.service_name = "demo_stack"
override.haproxy.incoming_port = 2345
override.haproxy.member_ports = demo_stack.ports

default.demo_stack.simulate.log = "/var/log/simulate.log"

override.logstash.server.inputs = [
  {
    :file => {
      :type => "demo_stack",
      :path => demo_stack.log
    }
  }
]

override.logstash.server.filters = [
  {
    :grep => {
      :type => "demo_stack",
      :match => ["@message", "request :"],
      :add_tag => ["request"],
      :drop => false
    }
  },
  {
    :grep => {
      :type => "demo_stack",
      :match => ["@message", "riak :"],
      :add_tag => ["riak"],
      :drop => false
    }
  },
  {
    :grok => {
      :type => "demo_stack",
      :pattern => '%{TIMESTAMP_ISO8601:timestamp} \| %{WORD:application} \| %{WORD:severity}%{SPACE}\| \[%{DATA:thread}\] \| %{DATA:class} \| %{GREEDYDATA:message}',
      :add_tag => ["grokked"]
    }
  },
  {
    :grok => {
      :type => "demo_stack",
      :tags => ["request", "grokked"],
      :match => ["message", '%{WORD} \:%{WORD:request_method} %{URIPATH:request_uri} %{INT:response_code} \(%{INT:response_time}ms\)'],
    }
  },
  {
    :grok => {
      :type => "demo_stack",
      :tags => ["riak", "grokked"],
      :match => ["message", '%{WORD} \:%{WORD:riak_operation} %{DATA:riak_key} \(%{INT:riak_time}ms\)'],
    }
  },
  {
    :multiline => {
      :type => "demo_stack",
      :pattern => "^20",
      :negate => true,
      :what => "previous"
    }
  },
  {
    :date => {
      :type => "demo_stack",
      :timestamp => "yyyy-MM-dd HH:mm:ss,SSS"
    }
  }
]

override.logstash.server.outputs = [
  {
    :graphite => {
      :fields => ["riak_operation", "riak_time"],
      :metrics => ["logstash.%{@type}.riak.%{riak_operation}.time", "%{riak_time}"]
    }
  }
]
