#!/usr/bin/env ruby
require 'pp'
require 'common'

def servers
  hosts     = []
  file      = File.expand_path(Common::config[:sshconf])
  open(file) do |config|
    config.read.split("\n").each do |line|
      match = /^Host\s(\w+.*)/i.match(line)
      hosts << match[1] unless match.nil?
    end
  end
  hosts
end

ofile = File.expand_path(Common::config[:outputfile])
open(ofile, 'w') do | file |
threads = []
servers.each do | s |
 threads << Thread.new do
   result = %x[ssh #{s} 'uptime']
   file.write s
   file.write result
 end
end

threads.each do | t |
 t.join
end
end
