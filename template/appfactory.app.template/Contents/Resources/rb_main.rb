framework 'Cocoa'

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

 def self.menu
  if not @menu
    @menu = NSMenu.new
    @menu.initWithTitle 'app_name'
    mi = NSMenuItem.new
    mi.title = 'Quit'
    mi.action = 'terminate:'
    mi.target = self
    @menu.addItem mi
    @menu
  else
    debug 'Meny already initialized...'
    @menu
  end
 end

 def self.terminate(sender)
   @app.terminate(self)
 end

 def self.status_bar
   if not @status_bar
    @status_bar = NSStatusBar.systemStatusBar
    @status_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)
    @status_item.setMenu menu 
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
end

$: << AppFactory.resources_dir
require 'growl'

AppFactory.start
