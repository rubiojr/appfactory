#
# Initialize the stuff
#
# We build the status bar item menu
def setupMenu
  menu = NSMenu.new
  menu.initWithTitle 'FooApp'
  mi = NSMenuItem.new
  mi.title = 'Hello from MacRuby!'
  mi.action = 'sayHello:'
  mi.target = self
  menu.addItem mi

  mi = NSMenuItem.new
  mi.title = 'Quit'
  mi.action = 'quit:'
  mi.target = self
  menu.addItem mi
  menu
end
def setupGrowl
  Growl::Notifier.sharedInstance.register 'FooApp', ['InitDone', 'SayHello', 'Terminate']
end

# Init the status bar
def init_app(menu)
  status_bar = NSStatusBar.systemStatusBar
  status_item = status_bar.statusItemWithLength(NSVariableStatusItemLength)
  status_item.setMenu menu 
  setupGrowl
  AppFactory.debug "Setting up Growl"
  bundle = NSBundle.mainBundle
  img = NSImage.new.initWithContentsOfFile "#{AppFactory.resources_dir}/macruby_logo.png"
  AppFactory.debug "Setting icon from #{AppFactory.resources_dir}/macruby_logo.png"
  status_item.setImage(img)
  Growl.growl 'InitDone', "FooApp", "Here we go!"
  status_bar
end

#
# Menu Item Actions
#
def sayHello(sender)
  Growl.growl 'SayHello', "FooApp", "Hiya!"
end

def quit(sender)
  app = NSApplication.sharedApplication
  Growl.growl 'InitDone', "FooApp", "Bye!!!"
  app.terminate(self)
end

