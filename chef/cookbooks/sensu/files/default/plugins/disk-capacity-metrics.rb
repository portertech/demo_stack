#!/usr/bin/env ruby
#
# Disk Capacity Metrics Plugin
# ===
#
# This plugin uses df to collect disk capacity metrics
# disk-metrics.rb looks at /proc/stat which doesnt hold capacity metricss.
# could have intetrated this into disk-metrics.rb, but thought I'd leave it up to
# whomever implements the checks.
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details.

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'socket'

class DiskCapacity < Sensu::Plugin::Metric::CLI::Graphite

  option :scheme,
         :description => "Metric naming scheme, text to prepend to metric",
         :long => "--scheme SCHEME",
         :default => "#{Socket.gethostname}.disk"

  def run
    `df -PT`.split("\n").drop(1).each do |line|
      begin
        fs, type, blocks, used, avail, capacity, mnt = line.split
        if mnt == '/'
          mnt = 'root'
        end
        timestamp = Time.now.to_i
        if fs.match('/dev')
          fs = fs.gsub('/dev/', '')
          metrics = {
            "#{fs}.used" => used,
            "#{fs}.avail" => avail,
            "#{fs}.capacity" => capacity.gsub('%','')
          }
          metrics.each do |metric_name, value|
            output "#{config[:scheme]}.#{metric_name}", value, timestamp
          end
        end
      rescue
        unknown "malformed line from df: #{line}"
      end
    end

    `df -Pi`.split("\n").drop(1).each do |line|
      begin
        fs, inodes, used, avail, capacity, mnt = line.split
        if mnt == '/'
          mnt = 'root'
        end
        timestamp = Time.now.to_i
        if fs.match('/dev')
          fs = fs.gsub('/dev/', '')
          metrics = {
            "#{fs}.iused" => used,
            "#{fs}.iavail" => avail,
            "#{fs}.capacity" => capacity.gsub('%', '')
          }
          metrics.each do |metric_name, value|
            output "#{config[:scheme]}.#{metric_name}", value, timestamp
          end
        end
      rescue
        unknown "malformed line from df: #{line}"
      end
    end

    ok
  end
end
