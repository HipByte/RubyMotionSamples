class SceneWindowController < NSWindowController
  attr_accessor :viewController
  
  def init
    super.tap do 
      mask = NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask
      self.window = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
                                    styleMask: mask,
                                      backing: NSBackingStoreBuffered,
                                        defer: false)
      self.window.delegate = self
      @viewController = SceneController.alloc.init
      self.window.title = @viewController.title
    end
  end
  
  def showWindow obj
    super
    window_customization
  end
  
  def text_label
    @text_label ||= NSTextField.alloc.initWithFrame(CGRect.new([0, 0], [200, 200])).tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.editable = false
      label.selectable  = false
      label.drawsBackground = true
      label.textColor = NSColor.blackColor
      label.bordered  = false
      label.alignment = NSLeftTextAlignment
      label.backgroundColor = NSColor.clearColor
      label.font = NSFont.fontWithName "Lucida Grande", size:14.0
      label.stringValue = "Hello World"
    end
  end
  
  def window_customization
    self.window.tap do |win|
      self.window.toolbar = NSToolbar.alloc.initWithIdentifier("Scenario Toolbar").tap do |tb|
        tb.allowsUserCustomization = true
        tb.autosavesConfiguration  = true
        tb.displayMode = NSToolbarDisplayModeIconOnly
        tb.delegate = self
      end
    end
    
    opts = { 'NSDisplayPattern' => "current time: %{value1}@"}
    text_label.bind "displayPatternValue1", toObject: viewController, withKeyPath: "self.view.currentTime", options: opts
    
    @viewController.view.translatesAutoresizingMaskIntoConstraints = false
    
    self.window.contentView.addSubview @viewController.view
    self.window.contentView.addSubview text_label
    
    views_dictionary = Hash['cview', @viewController.view, 'time_label', text_label]
    constraints = []
    constraints += NSLayoutConstraint.constraintsWithVisualFormat "H:|[cview]|", 
                                                          options:NSLayoutFormatAlignAllCenterY, 
                                                          metrics:nil,
                                                          views:views_dictionary
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat "H:|[time_label]|", 
                                                          options:NSLayoutFormatAlignAllCenterY, 
                                                          metrics:nil,
                                                          views:views_dictionary
    
    constraints += NSLayoutConstraint.constraintsWithVisualFormat "V:|[cview][time_label]|", 
                                                          options:NSLayoutFormatAlignAllCenterX, 
                                                          metrics:nil,
                                                          views:views_dictionary
    self.window.contentView.addConstraints constraints
  end 
end