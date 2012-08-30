include_recipe "gdash"

gdash_dashboard "Demo Stack" do
  category "Application"
  description "Application Metrics"
end

gdash_dashboard "Memory" do
  category "System"
  description "System Memory Metrics"
end

gdash_dashboard_component "Free" do
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

gdash_dashboard_component "Swap" do
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

gdash_dashboard_component "Buffers & Cached" do
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
