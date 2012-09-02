include_recipe "gdash"

gdash_dashboard "Demo Stack" do
  category "Application"
  description "Application Metrics"
end

gdash_dashboard "Memory" do
  category "System"
  description "System Memory Metrics"
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

gdash_dashboard_component "request_time" do
  dashboard_name "Demo Stack"
  dashboard_category "Application"
  ymin 0
  vtitle "Time (ms)"
  draw_null_as_zero true
  area :all
  fields(
    "Contacts.POST" => {
      :data => "api.request.contacts.post.time"
    },
    "contacts.GET" => {
      :data => "api.request.contacts.get.time"
    },
    "Contacts.PUT" => {
      :data => "api.request.contacts.put.time"
    },
    "Contacts.DELETE" => {
      :data => "api.request.contacts.delete.time"
    },
    "Ping.GET" => {
      :data => "api.request.ping.get.time"
    },
    "Fail.GET" => {
      :data => "api.request.fail.get.time"
    }
  )
end
