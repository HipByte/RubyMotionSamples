class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    @controller = MyWindowController.alloc.init
  end

  def openReadMe(sender)
    fullPath = NSBundle.mainBundle.pathForResource("ReadMe", ofType:"txt")
    NSWorkspace.sharedWorkspace.openFile(fullPath)
  end
end
