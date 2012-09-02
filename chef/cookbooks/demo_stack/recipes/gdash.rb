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
  vtitle "% Used"
  fields(
    :usage => {
      :data => "*.disk.*.capacity",
      :alias => "Disk Usage"
    }
  )
end

gdash_dashboard_component "requests_per_minute" do
  dashboard_name "Demo Stack"
  dashboard_category "Application"
  ymin 0
  draw_null_as_zero true
  area :stacked
  fields(
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

gdash_dashboard_component "average_request_time" do
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

gdash_dashboard_component "request_time" do
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

gdash_dashboard_component "riak_operation_time" do
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
