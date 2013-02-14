require "fileutils"

class MacInstall
  def initialize dmg
    @dmg = dmg
    @filename = File.basename @dmg, File.extname @dmg
    @mounted_path = nil

    raise_error_if_not_exists
  end

  def install
    begin
      @mounted_path = Dir.mktmpdir
      mount_dmg
      
      do_install
    ensure
      unmount_dmg
      FileUtils.remove_entry_secure @mounted_path
    end
  end

  private
  def raise_error_if_not_exists
    unless File.exists? @dmg
      raise "Unable to find dmg file '#{@dmg}'"
    end
  end

  def mount_dmg
    result = %x[hdiutil attach "#{@dmg}" -mountpoint #{@mounted_path}]
    unless $?.success?
      raise "Unable to mount dmg file '#{@dmg}'"
    end
    puts result
  end

  def unmount_dmg
    return if @mounted_path.nil?
    result = %[hdiutil umount "#{@mounted_path}"]
    unless $?.success?
      raise "Unable to unmount dmg file '#{@dmg}'"
    end
    puts result
  end

  def do_install
    # check files inside mounted path
    Dir.glob(File.join(@mounted_path, "*.app")).each do |app|
      install_app app
    end
    Dir.glob(File.join(@mounted_path, "*.pkg")).each do |pkg|
      install_pkg pkg
    end
  end

  def install_app app
    puts "Install app #{app}"
  end

  def install_pkg pkg
    puts "Install pkg #{pkg}"
  end
end
