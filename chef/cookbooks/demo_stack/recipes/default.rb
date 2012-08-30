#
# Cookbook Name:: demo_stack
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "riak"
include_recipe "java"
include_recipe "bluepill"

release_directory = File.join(node.demo_stack.directory, "releases")
jar_file = "demo_stack-#{node.demo_stack.version}-standalone.jar"
current_release = File.join(release_directory, jar_file)

user node.demo_stack.user do
  system true
  shell "/bin/false"
end

directory release_directory do
  recursive true
  mode 0755
end

directory File.dirname(node.demo_stack.log) do
  recursive true
  mode 0755
end

file node.demo_stack.log do
  owner node.demo_stack.user
  backup false
  mode 0755
end

remote_file current_release do
  source "https://github.com/downloads/portertech/demo_stack/#{jar_file}"
  mode 0755
  not_if { File.exists?(current_release) }
end

link File.join(node.demo_stack.directory, "demo_stack.jar") do
  to current_release
  notifies :restart, "bluepill_service[demo_stack]", :delayed
end

template "/etc/bluepill/demo_stack.pill"

bluepill_service "demo_stack" do
  action [:enable, :load, :start]
end

include_recipe "haproxy"
