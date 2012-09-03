default.demo_stack.directory = "/srv/demo_stack"
default.demo_stack.version = "1.0.0-SNAPSHOT"
default.demo_stack.user = "demo_stack"
default.demo_stack.log = "/var/log/demo_stack.log"
default.demo_stack.ports = [4000, 4001]

override.bluepill.bin = "/usr/local/bin/bluepill"

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
    :grok => {
      :type => "demo_stack",
      :pattern => '%{TIMESTAMP_ISO8601:timestamp} \| %{WORD:application} \| %{WORD:severity}%{SPACE}\| \[%{DATA:thread}\] \| %{DATA:class} \| %{GREEDYDATA:message}'
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
