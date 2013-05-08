class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    @controller = MyWindowController.alloc.init
  end
end
