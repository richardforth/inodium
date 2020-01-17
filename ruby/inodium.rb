#!/usr/bin/ruby

require 'find'

#=--------------------------------------------------------=#
# ScriptName : inodium.rb
# Author     : Richard A. Forth
# Email      : richardDOTforthATgmailDOTcom
# Version    : 0.01
# Description: Inode Hunter.
#=--------------------------------------------------------=#

# the successflag determines what happens on program exit, prevents duplicate reports being generated.
@successflag = 0

# A circular buffer class.
# A CircularBuffer can only hold a fixed number of objects. The oldest item is removed to retain equiilibrium.
class CircularBuffer

  # initialize the object with a size
  def initialize(size:)
    @max_size = size
    @buffer = []
  end

  # A shovel method used to add items to the CircularBuffer, note that if the buffer is full, the first item is removed. to make a space.
  def <<(value)
    if @buffer.size >= @max_size
      @buffer.shift
      @buffer << value if value[:count] > self.highest
    else
      @buffer << value unless @buffer.include?(value)
    end
  end

  # Returns the size of the buffer/
  def size
    @buffer.size
  end

  # returns the highest "count" - each item in the buffer has a path, and a count.
  def highest
    return 0 if @buffer.length == 0
    @buffer.sort_by { |hsh| hsh[:count] }[-1][:count]
  end

  # Return the unformatted buffer
  def report
    @buffer
  end
end

# is_dir? returns a boolean
def is_dir?(dir)
  File.directory?(dir)
end

# is_file? returns a boolean
def is_file?(path)
  File.file?(path)
end

# Produces a list of files and folders in a given dir
def list_one_deep(dir)
  dir = "/" + dir  unless dir.start_with?("/")
  dir = dir + "/" unless dir.end_with?("/")
  dirs = Dir.entries(dir)
  dirs = dirs - [dir + ".", dir + ".."]
  fulldirs = []
  dirs.each do |name|
    fulldirs << dir + name
  end
  fulldirs - [dir + ".", dir + ".."]
end

# A method that scans a directory and uses the CircularBuffer class as a buffer object
def scan(dir, buffer)
  puts "Scan started at #{Time.now}."
  @skipped = []
  arr = list_one_deep(dir)
  clear = "\r" + " " * 45 + "\r"
  arr.each do |path|
    if is_dir?(path)
      print clear
      message = "\rScanning #{path} ..."
      clear = "\r" + " " * message.length + "\r"
      print message
      Dir.chdir(path)
      count = Dir.glob("**/**").count
      count += Dir.glob("**/.*").count
      count += Dir.glob(".*/.*").count
      this_hash = {
        path: path,
        count: count
      }
      buffer << this_hash
    end
  end
  puts "\rScan completed at #{Time.now}."
end


# Create a circular buffer of 20 items.
myTopTwenty = CircularBuffer.new(size: 20)

# This at_exit forces a report out even if we quit the program early (perhaps if it is taking too long to respond)
at_exit do
  if @successflag == 1
    puts "\n\nDone.\n"
  else
    puts
    puts
    myTopTwenty.report.sort_by { |hsh| hsh[:count] }.reverse.each do |hash|
      string = "%-30d : %-70s" % [hash[:count], hash[:path]]
      puts string
    end
    puts
    puts "Scan terminated early at #{Time.now}."
    puts
  end
end


# Get the start position from ARGV, or default to /
if ARGV.length != 1
  puts "Defaulting to /"
  fs = "/"
else
  fs = ARGV[0]
  # CHECK IF THE FOLDER IS A REAL EXISTING FOLDER, OR ABORT.
  puts "FATAL: Not a valid folder," unless is_dir(fs)
  exit unless is_dir(fs)
end
puts
title = "Top 20 Directories in #{fs} for inodes"
puts title
puts "=" * title.length
puts
scan(fs, myTopTwenty)
puts
myTopTwenty.report.sort_by { |hsh| hsh[:count] }.reverse.each do |hash|
  string = "%-30d : %-70s" % [hash[:count], hash[:path]]
  puts string
end
@successflag = 1
puts
