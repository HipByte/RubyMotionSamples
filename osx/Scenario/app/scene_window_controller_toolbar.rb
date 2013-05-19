class SceneWindowController < NSWindowController
  PLAY_ITEM  = "Play"
  PAUSE_ITEM = "Pause"
  STOP_ITEM  = "STOP"
  LOOP_ITEM  = "Loop"
  NIGHT_DAY  = "OWN SHADER"


  def toolbarDefaultItemIdentifiers toolbar
    NSArray.arrayWithArray [
      PLAY_ITEM, 
      PAUSE_ITEM, 
      STOP_ITEM, 
      NSToolbarFlexibleSpaceItemIdentifier,
      NIGHT_DAY,
      NSToolbarFlexibleSpaceItemIdentifier,
      LOOP_ITEM
    ]
  end

  def toolbarAllowedItemIdentifiers toolbar
    NSArray.arrayWithArray [
      PLAY_ITEM, 
      PAUSE_ITEM, 
      STOP_ITEM, 
      NIGHT_DAY, 
      LOOP_ITEM,
      NSToolbarFlexibleSpaceItemIdentifier,
      NSToolbarSeparatorItemIdentifier,
      NSToolbarCustomizeToolbarItemIdentifier,
      NSToolbarShowFontsItemIdentifier
    ]
  end

  def toolbar tb, itemForItemIdentifier:identifier, willBeInsertedIntoToolbar:flag
    media_items = [PLAY_ITEM, PAUSE_ITEM, STOP_ITEM, LOOP_ITEM]
    item = NSToolbarItem.alloc.initWithItemIdentifier(identifier).tap do |item|
      if media_items.include? identifier
        # Set up a reasonable tooltip, and image   Note, these aren't localized, 
        # but you will likely want to localize many of the item's properties 
        item.view = NSButton.alloc.initWithFrame(CGRect.new([6, 23], [30, 30])).tap do |bt|
          bt.bezelStyle = NSCircularBezelStyle
          bt.buttonType = identifier == LOOP_ITEM || identifier == NIGHT_DAY ? NSSwitchButton : NSMomentaryPushInButton
        end
        
        # Tell the item what message to send when it is clicked 
        item.minSize = CGSize.new(39, 38)
        item.maxSize = CGSize.new(39, 38)
        case identifier
        
        when PLAY_ITEM
          item.toolTip = "Play Scenario"
          item.label = "Play"
          item.paletteLabel = "Play"
          item.image = NSImage.imageNamed "Cue-Play"
        
        when PAUSE_ITEM
          item.toolTip = "Pause Scenario"
          item.label = "Pause"
          item.paletteLabel = "Pause"
          item.image = NSImage.imageNamed "Cue-Pause"
                    
        when LOOP_ITEM
          item.minSize = CGSize.new(50, 30)
          item.maxSize = CGSize.new(50, 38)
          
          item.toolTip = "Looping Scenario"
          item.label = "Loop"
          item.view.title = "Looping"
          item.paletteLabel = "Loop"
        
        when STOP_ITEM
          item.toolTip = "Stop Scenario"
          item.label = "Stop"
          item.paletteLabel = "Stop"
          item.image = NSImage.imageNamed "Cue-Stop"
        end
        
      elsif identifier == NIGHT_DAY
        item.view = NSSegmentedControl.alloc.init.tap do |segment|
          segment.segmentCount = 2
          segment.segmentStyle =  NSSegmentStyleTexturedRounded #NSSegmentStyleAutomatic
          
          segment.setLabel "Day", forSegment:0
          segment.setWidth 50.0,  forSegment:0
          
          segment.setLabel "Night", forSegment:1
          segment.setWidth 50.0,  forSegment:1
        end
        
        item.minSize = CGSize.new(110,30)
        item.maxSize = CGSize.new(110,30)
        item.toolTip = "Shader"
        item.label = "Shader"
        item.paletteLabel = "Shader"
      end
    end
  end
  
  
  def toolbarWillAddItem note
    item = note.userInfo['item']
    case item.itemIdentifier
    when PLAY_ITEM
      item.target = viewController.view
      item.action = 'play:'
    
    when PAUSE_ITEM
      item.target = viewController.view
      item.action = 'pause:'
    
    when STOP_ITEM
      item.target = viewController.view
      item.action = 'stop:'
    
    when NIGHT_DAY
      item.target = viewController
      item.action = 'change_shader:'
      item.view.selectedSegment = 0
      
    when LOOP_ITEM
      item.view.bind "value", toObject:viewController, withKeyPath:"self.view.loops", options: {
        NSContinuouslyUpdatesValueBindingOption => true,
        NSAllowsEditingMultipleValuesSelectionBindingOption => true,
        NSConditionallySetsEditableBindingOption => true,
        NSRaisesForNotApplicableKeysBindingOption => true
      }
    end
  end 
end
