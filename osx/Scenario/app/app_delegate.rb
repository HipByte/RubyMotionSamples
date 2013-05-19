class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    @win_controller = SceneWindowController.alloc.init
    @win_controller.showWindow self
  end
end
