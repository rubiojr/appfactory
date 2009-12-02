framework 'Cocoa'
$: << NSBundle.mainBundle.resourcePath.fileSystemRepresentation
require 'growl'

module AppFactory
 def self.resources_dir
   NSBundle.mainBundle.resourcePath.fileSystemRepresentation
 end

 def self.app_name
   @app_name || 'AppFactory'
 end

 def self.app_name=(name)
   @app_name = name
 end

 def self.debug(msg)
   NSLog "DEBUG [#{app_name}]: #{msg}"
 end

 def register_growl_events(array = [])
   a = array.map { |e| e.to_s }
   Growl::Notifier.sharedInstance.register AppFactory.app_name, array
 end

 def growl(event_name, title, desc)
   Growl.growl event_name.to_s, title, desc
 end

 def self.top_menu
  if not @top_menu
    @top_menu = NSMenu.new
    @top_menu.initWithTitle app_name
    @top_menu
  else
    debug 'Meny already initialized...'
    @top_menu
  end
 end

 def clear_menu(menu)
   menu.itemArray.each do |mi|
     menu.removeItem mi
   end
 end

 def self.terminate
   @app.terminate(self)
 end

 def open_url(url)
   NSWorkspace.sharedWorkspace.openURL(NSURL.URLWithString(url))
 end

 def self.status_bar
   if not @status_bar
    @status_bar = NSStatusBar.systemStatusBar
    @status_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)
    @status_item.setMenu top_menu 
    img = NSImage.new.initWithContentsOfFile "#{AppFactory.resources_dir}/ruby_statusbar.png"
    @status_item.setImage(img)
    Growl.growl 'InitDone', app_name, "Here we go!"
    @status_bar
   else
    debug 'Statusbar already initialized...'
     @status_bar
   end
 end

 def self.start
   @app = NSApplication.sharedApplication
   status_bar
   @app.run
 end
 
 def timer(interval, &block)
    delegate = TimerDelegate.new
    @timer = NSTimer.scheduledTimerWithTimeInterval interval.to_f, :target => delegate, :selector => "runTimer:", :userInfo => nil, :repeats => true
    TimerDelegate.send(:class_eval, "def timerBlock=(blk); @timerBlock = blk; end")
    delegate.send("timerBlock=".to_sym, block)
 end

 def menu_item(title, &block)
    mi = NSMenuItem.new
    mi.title = title
    dname = "delegate#{rand(999999999)}"
    mi.action = "#{dname}:"
    AppFactoryDelegate.send(:class_eval, "def #{dname}=(blk); @#{dname} = blk; end")
    AppFactoryDelegate.send(:class_eval, "def #{dname}(sender); @#{dname}.call ; end")
    delegate = AppFactory.delegate
    delegate.send("#{dname}=".to_sym, block)
    mi.target = delegate
    if @current_menu
      @current_menu.addItem mi
    else
      AppFactory.menu.addItem mi
    end
 end
 
 def menu_separator
    if @current_menu
      @current_menu.addItem NSMenuItem.separatorItem
    else
      puts NSMenuItem.separatorItem
      AppFactory.top_menu.addItem NSMenuItem.separatorItem
    end
 end

 def menu_quit
    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    mi.target = AppFactory.delegate
    AppFactory.top_menu.addItem mi
 end
 
 def menu(title)
   if not @submenues
     AppFactory.debug 'Init submenues collection'
     @submenues = {}
   end
    m = nil
    if @submenues.has_key? title
      #existing menu
      AppFactory.debug "Submenu #{title} already exists"
      m = @submenues[title]
    else
      AppFactory.debug "Creating submenu #{title}"
      m = NSMenu.new
      @submenues[title] = m
      m.initWithTitle title
      mi = NSMenuItem.new
      mi.title = title
      mi.setSubmenu m
      AppFactory.top_menu.addItem mi
    end
    @current_menu = m
    yield m
    @current_menu = nil
 end

 def self.delegate
   @delegate ||= AppFactoryDelegate.new
 end

 def self.vendor_libs
   Dir["#{resources_dir}/vendor/gems/gems/*"].each do |d|
     AppFactory.debug "Adding #{d}/lib to RUBYLIB"
     $: << "#{d}/lib"
   end
 end

 class TimerDelegate
   def runTimer(timer)
     @timerBlock.call
   end
 end
 class AppFactoryDelegate
   def terminate(sender)
     AppFactory.terminate
   end
 end

end

AppFactory.vendor_libs
include AppFactory
require 'dsl'

AppFactory.start
