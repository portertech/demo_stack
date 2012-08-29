include_recipe 'gdash'

gdash_dashboard 'Carbon Metrics' do
  category 'Carbon'
  description 'Graphite Carbon Metrics'
end

gdash_dashboard_component 'Metrics Received' do
  dashboard_name 'Carbon Metrics'
  dashboard_category 'Carbon'
  vtitle 'Items'
  fields(
    :received => {
      :data => '*.*.*.metricsReceived',
      :alias => 'Metrics Received'
    }
  )
end

gdash_dashboard_component 'cpu' do
  dashboard_name 'Carbon Metrics'
  dashboard_category 'Carbon'
  fields(
    :cpu => {
      :data => '*.*.*.cpuUsage',
      :alias => 'CPU Usage'
    }
  )
end

gdash_dashboard_component 'memory' do
  dashboard_name 'Carbon Metrics'
  dashboard_category 'Carbon'
  fields(
    :memory => {
      :data => '*.*.*.memUsage',
      :alias => 'Memory Usage'
    }
  )
end
