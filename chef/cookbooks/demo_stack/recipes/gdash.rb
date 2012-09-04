include_recipe "gdash"

gdash_dashboard "CPU" do
  category "System"
  description "System CPU Metrics"
end

gdash_dashboard "Memory" do
  category "System"
  description "System Memory Metrics"
end

gdash_dashboard "Disk" do
  category "System"
  description "System Disk Metrics"
end

gdash_dashboard "Demo Stack" do
  category "Application"
  description "Application Metrics"
end

gdash_dashboard "Logstash Metrics" do
  category "Logstash"
  description "Logstash Metrics"
end

gdash_dashboard_component "cpu_usage" do
  dashboard_name "CPU"
  dashboard_category "System"
  ymin 0
  vtitle "% Utilized"
  fields(
    :usage => {
      :data => "*.cpu.usage",
      :alias => "CPU Usage"
    }
  )
end

gdash_dashboard_component "free_memory" do
  dashboard_name "Memory"
  dashboard_category "System"
  fields(
    :free => {
      :data => "*.memory.free",
      :alias => "Free Memory"
    },
    :freeWOBuffersCaches => {
      :data => "*.memory.freeWOBuffersCaches",
      :alias => "Free Memory Without Buffers & Caches"
    }
  )
end

gdash_dashboard_component "free_swap" do
  dashboard_name "Memory"
  dashboard_category "System"
  ymin 0
  fields(
    :free => {
      :data => "*.memory.swapFree",
      :alias => "Free Swap"
    },
    :total => {
      :data => "*.memory.swapTotal",
      :alias => "Total Swap"
    }
  )
end

gdash_dashboard_component "buffers_and_cached" do
  dashboard_name "Memory"
  dashboard_category "System"
  fields(
    :buffers => {
      :data => "*.memory.buffers"
    },
    :cached => {
      :data => "*.memory.cached"
    }
  )
end

gdash_dashboard_component "disk_usage" do
  dashboard_name "Disk"
  dashboard_category "System"
  ymin 0
  ymax 100
  vtitle "% Used"
  lines [
    {
      :caption => "Warning",
      :value => 85,
      :color => "orange",
      :dashed => true
    },
    {
      :caption => "Critical",
      :value => 95,
      :color => "red"
    }
  ]
  fields(
    :xvda1 => {
      :data => "*.disk.xvda1.capacity",
      :alias => "xvda1"
    },
    :xvdb => {
      :data => "*.disk.xvdb.capacity",
      :alias => "xvdb"
    }
  )
end

gdash_dashboard_component "a_average_response_time" do
  dashboard_name "Demo Stack"
  dashboard_category "Application"
  ymin 0
  vtitle "Time (ms)"
  area :all
  fields(
    :average => {
      :data => "averageSeries(api.request.*.*.time)",
      :alias => "Average Response Time"
    }
  )
end

gdash_dashboard_component "b_requests_per_minute" do
  dashboard_name "Demo Stack"
  dashboard_category "Application"
  ymin 0
  area :stacked
  fields(
    :deploy => {
      :data => "drawAsInfinite(chef.*.demo_stack_deploy)",
      :color => "blue",
      :alias => "Demo Stack Deploy"
    },
    :errors => {
      :data => "sumSeries(summarize(api.request.*.*.5*, '1min'))",
      :color => "red",
      :alias => "Errors"
    },
    :requests => {
      :data => "sumSeries(summarize(api.request.*.*.[2-4]*, '1min'))",
      :color => "green",
      :alias => "Requests"
    }
  )
end

gdash_dashboard_component "c_riak_operation_time" do
  dashboard_name "Demo Stack"
  dashboard_category "Application"
  ymin 0
  vtitle "Time (ms)"
  fields(
    :store => {
      :data => "api.riak.store.time",
      :alias => "Riak STORE"
    },
    :fetch => {
      :data => "api.riak.fetch.time",
      :alias => "Riak FETCH"
    },
    :delete => {
      :data => "api.riak.delete.time",
      :alias => "Riak DELETE"
    }
  )
end

gdash_dashboard_component "d_response_time" do
  dashboard_name "Demo Stack"
  dashboard_category "Application"
  ymin 0
  vtitle "Time (ms)"
  area :all
  fields(
    :contacts_post => {
      :data => "api.request.contacts.post.time",
      :alias => "Contacts POST"
    },
    :contacts_get => {
      :data => "api.request.contacts.get.time",
      :alias => "Contacts GET"
    },
    :contacts_put => {
      :data => "api.request.contacts.put.time",
      :alias => "Contacts PUT"
    },
    :ping_get => {
      :data => "api.request.ping.get.time",
      :alias => "Ping GET"
    },
    :contacts_delete => {
      :data => "api.request.contacts.delete.time",
      :alias => "Contacts DELETE"
    },
    :fail_get => {
      :data => "api.request.fail.get.time",
      :alias => "Fail GET"
    }
  )
end

gdash_dashboard_component "e_riak_operation_time" do
  dashboard_name "Demo Stack"
  dashboard_category "Application"
  ymin 0
  vtitle "Time (ms)"
  fields(
    :store => {
      :data => "logstash.demo_stack.riak.store.time",
      :alias => "(LOG) Riak STORE"
    },
    :fetch => {
      :data => "logstash.demo_stack.riak.fetch.time",
      :alias => "(LOG) Riak FETCH"
    },
    :delete => {
      :data => "logstash.demo_stack.riak.delete.time",
      :alias => "(LOG) Riak DELETE"
    }
  )
end

gdash_dashboard_component "logstash_events" do
  dashboard_name "Logstash Metrics"
  dashboard_category "Logstash"
  vtitle "Items"
  fields(
    :received => {
      :data => "summarize(logstash.events, '1min')",
      :alias => "Events Received"
    }
  )
end
