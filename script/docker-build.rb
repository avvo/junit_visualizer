#!/usr/bin/env ruby
# == Synopsis
#
# This script builds a docker image with the appropriate arguments
#
# == Usage
#    docker-build
#         [ -h | --help ]                       Prints synopsis and usage
#

require 'optparse'

opts = OptionParser.new
opts.on("-h", "--help") { usage(opts) }
opts.parse!(ARGV)

puts "COLLECTING BUILD INFORMATION..."
commit =  `git rev-parse HEAD`
date =  `date`
branch =  `git rev-parse --abbrev-ref HEAD`
image_name = "avvo/junit_visualizer:#{branch.gsub(/\//, "_")}"

puts "COMPOSING BUILD COMMAND..."
command = "docker build --build-arg SOURCE_COMMIT=#{commit} --build-arg BUILD_TIMESTAMP='#{date}' --build-arg SOURCE_BRANCH=#{branch} ./ -t #{image_name}".delete("\n")

puts "EXECUTING BUILD"
puts command
exec command
puts "DONE! FINISHED BUILDING #{image_name}"



def usage(_opts)
  puts "Usage: "
  puts "  docker-build"
  puts "  Builds the local Dockerfile. There are no other options."
  exit(0)
end
