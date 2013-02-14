require "./dmg.rb"

class MacInstall
  def initialize dmg
    @dmg = dmg
    @filename = File.basename(@dmg, File.extname(@dmg))
    @mounted_path = nil
  end

  def install
    begin
      puts "Installation of '#{@filename}'"
      puts ""

      dmg = Dmg.new @dmg
      print "  Mount   '#{@filename}'\t\t"
      dmg.mount
      puts "OK"

      do_install dmg.path
    ensure
      print "  Unmount '#{@filename}'\t\t"
      dmg.unmount
      puts "OK"
    end
  end

  private
  def do_install path
    # check files inside mounted path
    Dir.glob(File.join(path, "*.app")).each do |app|
      install_app app
    end
    Dir.glob(File.join(path, "*.pkg")).each do |pkg|
      install_pkg pkg
    end
  end

  def install_app app
    print "  Install '#{@filename}\t\t#{File.basename(app)}\t"
    result = %x[sudo cp -R "#{app}" /Applications]
    unless $?.success?
      puts "KO"
      puts result
      raise "Unable to install '#{app}'"
    end
  end

  def install_pkg pkg
    print "  Install '#{@filename}\t\t#{File.basename(pkg)}\t"
    result = %x[sudo installer -package "#{pkg}" -target "/Volumes/Macintosh HD"]
    unless $?.success?
      puts "KO"
      puts result
      raise "Unable to install '#{pkg}'"
    end
  end
end
