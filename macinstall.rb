require "fileutils"
require "tmpdir"

class MacInstall
  def initialize dmg
    @dmg = dmg
    @filename = File.basename(@dmg, File.extname(@dmg))
    @mounted_path = nil

    raise_error_if_not_exists
  end

  def install
    begin
      puts "Installation of '#{@filename}'"
      puts ""
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
    print "  Mount   '#{@filename}'\t\t"
    result = %x[hdiutil attach "#{@dmg}" -mountpoint #{@mounted_path}]
    unless $?.success?
      puts "KO"
      raise "Unable to mount dmg file '#{@dmg}'"
    end
    puts "OK"
  end

  def unmount_dmg
    return if @mounted_path.nil?
    print "  Unmount '#{@filename}'\t\t"
    result = %x[hdiutil unmount "#{@mounted_path}"]
    unless $?.success?
      puts "KO"
      raise "Unable to unmount dmg file '#{@dmg}'"
    end
    puts "OK"
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
    puts "  Install '#{@filename}\t\t#{File.basename(app)}"
  end

  def install_pkg pkg
    puts "  Install '#{@filename}\t\t#{File.basename(app)}"
  end
end
