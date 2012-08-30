default.demo_stack.directory = "/srv/demo_stack"
default.demo_stack.version = "1.0.0-SNAPSHOT"
default.demo_stack.user = "demo_stack"
default.demo_stack.ports = [4000, 4001]

override.haproxy.incoming_port = 2345
override.haproxy.member_ports = demo_stack.ports
