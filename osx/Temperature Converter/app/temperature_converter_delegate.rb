class TemperatureConverterDelegate

  def initialize
    mask = NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask#|NSResizableWindowMask
    backing = NSBackingStoreBuffered
    rect = NSRect.new([240, 180], [560, 275])
    window = NSWindow.alloc.initWithContentRect(rect, styleMask: mask, backing: backing, defer: false)
    @windowController = WindowController.new(window)
    @window = @windowController.window
  end

  attr_reader :window, :windowController

  def applicationDidFinishLaunching(notification)
    buildMenu
    self.window.orderFrontRegardless
  end
end