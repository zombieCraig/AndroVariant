#!/usr/bin/ruby
# Android Variant Tool
#
# A tool used to determine relationships of already detected malware
# The purpose is to determine the percentage of common code between
# known malware. This tool is meat to be used to assist in discussion
# purposes and to test out new theories and concepts.  It is not
# meant to detect malware.
#
# (cc) BY-SA Craig Smith - agent.craig@gmail.com

require File.join('metasm', 'metasm')
require 'zip/zipfilesystem'
require 'AndroVOptions'

include Zip
include Metasm

@opt = AndroVOptions.new

target = ARGV[0]

if not target
  puts "Please specify an apk file"
  exit
end

if @opt.options[:plugins].size == 0 then
  puts "You must specify at least one plugin."
  exit
end

if target=~/\.apk$/i then
  zipFile = ZipFile.open(target)
  @dex = DEX.load zipFile.file.open("classes.dex").read
elsif target=~/\.dex$/i then
  @dex = DEX.load File.new(target, "r").read
else
  puts "Expected APK or DEX file"
  exit
end

@dex.decode
@dasm = @dex.disassembler

def time(plugin)
  puts "Starting plugin #{plugin}" if @opt.options[:verbose]
  start = Time.now
  yield
  elapsed_time = Time.now - start
  puts "Finished plugin #{plugin} in #{elapsed_time}" if @opt.options[:verbose]
end

@opt.options[:plugins].each do |plugin|
  if File.exists? plugin then
    require plugin
    class_name = File.basename(plugin).gsub(/\.rb$/, '')
    time(class_name) do
      p = eval(class_name).new(@dex, @dasm)
      p.load_config
      p.analyze
      p.report
    end
  else
    puts "Could not find plugin file #{plugin}"
  end
end
   


