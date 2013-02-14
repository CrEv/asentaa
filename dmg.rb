require "fileutils"
require "tmpdir"

class Dmg
  def initialize file
    @file = file
    @filename = File.basename @file
    @mounted_path = nil
  end

  def path
    @mounted_path
  end

  def mount
    unless File.exists? @file
      raise "Dmg file '#{@file}' not found."
    end
    unless @mounted_path.nil?
      raise "Unable to mount dmg '#{@file}'. File is already mount in '#{@mounted_path}'".
    end
    @mounted_path = Dir.mktmpdir
    %x[hdiutil attach "#{@file}" -mountpoint #{@mounted_path}]
    unless $?.success?
      @mounted_path = nil
      raise "Unable to mount '#{@file}'"
    end
  end

  def unmount
    unless File.exists? @file
      raise "Dmg file '#{@file}' not found."
    end
    if @mounted_path.nil?
      raise "Dmg file '#{@file}' not mount"
    end
    %x[hdiutil unmount "#{@mounted_path}"]
    unless $?.success?
      raise "Unable to unmount '#{@file}'"
    end
    @mounted_path = nil
    FileUtils.remove_entry_secure @mounted_path
  end
end
