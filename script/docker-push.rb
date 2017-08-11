#!/usr/bin/env ruby
# == Synopsis
#
# This script pushes an im age to docker hub
#
# == Usage
#    docker-push
#         [ -h | --help ]                       Prints synopsis and usage
#

require 'optparse'

def usage(_opts)
  puts "Usage: "
  puts "  docker-push"
  puts "  Pushes the local image names avvo/junit_visualizer:{tag} to docker hub."
  puts "  There are no other options."
  exit(0)
end

opts = OptionParser.new
opts.on("-h", "--help") { usage(opts) }
opts.parse!(ARGV)

puts "COLLECTING BUILD INFORMATION..."
branch =  `git rev-parse --abbrev-ref HEAD`
image_name = "avvo/junit_visualizer:#{branch.gsub(/\//, "_")}"
puts "COMPOSING PUSH COMMAND..."
puts "PUSHING #{image_name}"
command = "docker push #{image_name}"
puts "DONE! FINISHED PUSHING #{image_name}"
exec command
