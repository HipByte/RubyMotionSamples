class MyWindowController < NSWindowController
  def init
    super
    buildWindow

    @slideView.setWantsLayer(true) # this can also be set in IB

    @donPedro1 = NSImage.imageNamed("Lake Don Pedro1")
    @donPedro2 = NSImage.imageNamed("Lake Don Pedro2")

    # build the popup menu of transitions, the second part of the popup is built dynamically based
    # on what Core Images gives us:
    #

    # Core Animation's four built-in transition types
    popupChoices = [KCATransitionFade, KCATransitionMoveIn, KCATransitionPush, KCATransitionReveal]
    transitions = CIFilter.filterNamesInCategories(NSArray.arrayWithObject(KCICategoryTransition))
    popupChoices += transitions if transitions.count > 0
    @transitionChoicePopup.addItemsWithTitles(popupChoices)

    # pick the default transition
    idx = @transitionChoicePopup.indexOfSelectedItem
    @transitionStyle = @transitionChoicePopup.itemTitleAtIndex(idx)
    @slideView.transitionToImage(@donPedro1)
    @curSlide1 = true

    self
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect(NSMakeRect(240, 180, 467, 410),
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = "Lake Don Pedro"
    @mainWindow.delegate = self
    @mainWindow.setMinSize(NSMakeSize(467, 432))
    @mainWindow.orderFrontRegardless

    @slideView = SlideshowView.alloc.initWithFrame(NSMakeRect(20, 69, 427, 321))
    @slideView.setAutoresizingMask(NSViewWidthSizable|NSViewHeightSizable)
    @mainWindow.contentView.addSubview(@slideView)

    label = NSTextField.alloc.initWithFrame(NSMakeRect(10, 25, 75, 14))
    label.stringValue = "Transitions:"
    label.bordered = false
    label.editable = false
    label.drawsBackground = false
    label.setAutoresizingMask(NSViewMaxXMargin|NSViewMaxYMargin)
    @mainWindow.contentView.addSubview(label)

    @transitionChoicePopup = NSPopUpButton.alloc.initWithFrame(NSMakeRect(87, 20, 243, 22))
    @transitionChoicePopup.setAutoresizingMask(NSViewMinYMargin)
    @transitionChoicePopup.setAction("transitionChoiceAction:")
    @transitionChoicePopup.setTarget(self)
    @transitionChoicePopup.setAutoresizingMask(NSViewMaxXMargin|NSViewMaxYMargin)
    @mainWindow.contentView.addSubview(@transitionChoicePopup)

    button = NSButton.alloc.initWithFrame(NSMakeRect(367, 19, 80, 23))
    button.title = "Go"
    button.setAction("goTransitionAction:")
    button.setTarget(self)
    button.bezelStyle = NSSmallSquareBezelStyle
    button.setAutoresizingMask(NSViewMinXMargin|NSViewMinYMargin|NSViewMaxYMargin)
    @mainWindow.contentView.addSubview(button)
  end

  def goTransitionAction(sender)
    if @curSlide1
      @slideView.transitionToImage(@donPedro2)
      @curSlide1 = false # we are not showing slide #1
    else
      @slideView.transitionToImage(@donPedro1)
      @curSlide1 = true  # we are showing slide #1
    end
  end

  def setTransitionStyle(newTransitionStyle)
    if @transitionStyle != newTransitionStyle
      @transitionStyle = newTransitionStyle
      @slideView.updateSubviewsWithTransition(@transitionStyle)
    end
  end

  def transitionChoiceAction(sender)
    idx = @transitionChoicePopup.indexOfSelectedItem
    self.transitionStyle = @transitionChoicePopup.itemTitleAtIndex(idx)
  end
end