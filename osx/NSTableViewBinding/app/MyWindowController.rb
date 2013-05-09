class MyWindowController < NSWindowController
  attr_reader :window

  def init
    super
    @myContentArray = NSArrayController.alloc.init
    buildWindow
    buildBinding
    self
  end

  def buildWindow
    @window = NSWindow.alloc.initWithContentRect([[240, 180], [432, 295]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @window.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @window.setMinSize(NSMakeSize(432, 261))
    @window.orderFrontRegardless

    scroll_view = NSScrollView.alloc.initWithFrame(NSMakeRect(20, 107, 392, 168))
    scroll_view.setAutoresizingMask(NSViewWidthSizable|NSViewHeightSizable)
    scroll_view.setHasVerticalScroller(true)
    scroll_view.setHasHorizontalScroller(true)
    scroll_view.setBorderType(NSBezelBorder)
    @window.contentView.addSubview(scroll_view)

    @myTableView = NSTableView.alloc.init
    @myTableView.setUsesAlternatingRowBackgroundColors(true)
    scroll_view.setDocumentView(@myTableView)

    column_first_name = NSTableColumn.alloc.initWithIdentifier("firstname")
    column_first_name.headerCell.setTitle("First Name")
    column_first_name.editable = false
    column_first_name.width = 94
    @myTableView.addTableColumn(column_first_name)

    column_last_name = NSTableColumn.alloc.initWithIdentifier("lastname")
    column_last_name.headerCell.setTitle("Last Name")
    column_last_name.editable = false
    column_last_name.width = 188
    @myTableView.addTableColumn(column_last_name)

    column_phone = NSTableColumn.alloc.initWithIdentifier("phone")
    column_phone.headerCell.setTitle("Phone")
    column_phone.editable = false
    column_phone.width = 99
    @myTableView.addTableColumn(column_phone)

    @myFormFields = NSForm.alloc.initWithFrame(NSMakeRect(11, 10, 226, 73))
    @myFormFields.setAutoresizingMask(NSViewMaxYMargin|NSViewWidthSizable)
    @myFormFields.setCellSize(NSMakeSize(226, 19))
    @myFormFields_first_cell = @myFormFields.addEntry("firstname")
    @myFormFields_first_cell.setTitle("First:")
    @myFormFields_last_cell = @myFormFields.addEntry("lastname")
    @myFormFields_last_cell.setTitle("Last:")
    @myFormFields_phone_cell = @myFormFields.addEntry("phone")
    @myFormFields_phone_cell.setTitle("Phone:")
    @myFormFields.setKeyCell(@myFormFields_first_cell)
    @myFormFields.setKeyCell(@myFormFields_last_cell)
    @myFormFields.setKeyCell(@myFormFields_phone_cell)
    @window.contentView.addSubview(@myFormFields)

    @removeButton = NSButton.alloc.initWithFrame(NSMakeRect(259, 13, 80, 28))
    @removeButton.setTitle("Remove")
    @removeButton.setAction("remove:")
    @removeButton.setTarget(self)
    @removeButton.setBezelStyle(NSRoundedBezelStyle)
    @removeButton.setAutoresizingMask(NSViewMinXMargin)
    @window.contentView.addSubview(@removeButton)

    @addButton = NSButton.alloc.initWithFrame(NSMakeRect(337, 13, 80, 28))
    @addButton.setTitle("Add")
    @addButton.setAction("add:")
    @addButton.setTarget(self)
    @addButton.setBezelStyle(NSRoundedBezelStyle)
    @addButton.setAutoresizingMask(NSViewMinXMargin)
    @window.contentView.addSubview(@addButton)
  end

  def buildBinding
    # Your NSTableView's content needs to use Cocoa Bindings,
    # use Interface Builder to setup the bindings like so:

    # Each column in the NSTableView needs to use Cocoa Bindings,
    # use Interface Builder to setup the bindings like so:

    #      columnIdentifier: "firstname"
    #          "value" = arrangedObjects.firstname [NSTableArray (NSArrayController)]
    #              Bind To: "TableArray" object (NSArrayController)
    #              Controller Key = "arrangedObjects"
    #              Model Key Path = "firstname" ("firstname" is a key in "TableArray")

    #      columnIdentifier: "lastname"
    #          "value" = arrangedObjects.lastname [NSTableArray (NSArrayController)]
    #              Bind To: "TableArray" object (NSArrayController)
    #              Controller Key = "arrangedObjects"
    #              Model Key Path = "lastname" ("lastname" is a key in "TableArray")

    #      columnIdentifier: "phone"
    #          "value" = arrangedObjects.phone [NSTableArray (NSArrayController)]
    #              Bind To: "TableArray" object (NSArrayController)
    #              Controller Key = "arrangedObjects"
    #              Model Key Path = "phone" ("phone" is a key in "TableArray")

    # or do bindings by code:
    firstNameColumn = @myTableView.tableColumnWithIdentifier("firstname")
    firstNameColumn.bind("value", toObject:@myContentArray, withKeyPath:"arrangedObjects.firstname", options:nil)

    lastNameColumn = @myTableView.tableColumnWithIdentifier("lastname")
    lastNameColumn.bind("value", toObject:@myContentArray, withKeyPath:"arrangedObjects.lastname", options:nil)

    phoneColumn = @myTableView.tableColumnWithIdentifier("phone")
    phoneColumn.bind("value", toObject:@myContentArray, withKeyPath:"arrangedObjects.phone", options:nil)

    # for NSTableView "double-click row" to work you need to use Cocoa Bindings,
    # use Interface Builder to setup the bindings like so:

    #  NSTableView:
    #      "doubleClickArgument":
    #          Bind To: "TableArray" object (NSArrayController)
    #              Controller Key = "selectedObjects"
    #              Selector Name = "inspect:" (don't forget the ":")

    #      "doubleClickTarget":
    #          Bind To: (File's Owner) MyWindowController
    #              Model Key Path = "self"
    #              Selector Name = "inspect:" (don't forget the ":")

    #  ... also make sure none of the NSTableColumns are "editable".

    # or do bindings by code:
    doubleClickOptionsDict = {"NSSelectorName" => "inspect:", "NSConditionallySetsHidden" => true, "NSRaisesForNotApplicableKeys" => true}
    @myTableView.bind("doubleClickArgument", toObject:@myContentArray, withKeyPath:"selectedObjects", options:doubleClickOptionsDict)
    @myTableView.bind("doubleClickTarget", toObject:self, withKeyPath:"self", options:doubleClickOptionsDict)

    # the enabled states of the two buttons "Add", "Remove" are bound to "canRemove"
    # use Interface Builder to setup the bindings like so:

    #  NSButton ("Add")
    #      "enabled":
    #          Bind To: "TableArray" object (NSArrayController)
    #              Controller Key = "canAdd"

    #  NSButton ("Remove")
    #      "enabled":
    #          Bind To: "TableArray" object (NSArrayController)
    #              Controller Key = "canRemove"

    # or do bindings by code:
    enabledOptionsDict = {"NSRaisesForNotApplicableKeys" => true}
    @addButton.bind("enabled", toObject:@myContentArray, withKeyPath:"canAdd", options:enabledOptionsDict)
    @removeButton.bind("enabled", toObject:@myContentArray, withKeyPath:"canRemove", options:enabledOptionsDict)

    # the NSForm's text fields is bound to the current selection in the NSTableView's content array controller,
    # use Interface Builder to setup the bindings like so:

    #  NSFormCell:
    #      "value":
    #          Bind To: "TableArray" object (NSArrayController)
    #              Controller Key = "selection"
    #              Model Key Path = "firstname"

    # or do bindings by code:
    valueOptionsDict = {"NSAllowsEditingMultipleValuesSelection" => true, "NSConditionallySetsEditable" => true, "NSRaisesForNotApplicableKeys" => true}
    @myFormFields.cellAtIndex(0).bind("value", toObject:@myContentArray, withKeyPath:"selection.firstname", options:valueOptionsDict)
    @myFormFields.cellAtIndex(1).bind("value", toObject:@myContentArray, withKeyPath:"selection.lastname", options:valueOptionsDict)
    @myFormFields.cellAtIndex(2).bind("value", toObject:@myContentArray, withKeyPath:"selection.phone", options:valueOptionsDict)

    # start listening for selection changes in our NSTableView's array controller
    @myContentArray.addObserver(self, forKeyPath:"selectionIndexes", options:NSKeyValueObservingOptionNew, context:nil)

    # finally, add the first record in the table as a default value.

    # note: to allow the external NSForm fields to alter the table view selection through the "value" bindings,
    # added objects to the content array needs to be an "NSMutableDictionary" -
    dict = {"firstname" => "Joe", "lastname" => "Smith", "phone" => "(444) 444-4444"}
    @myContentArray.addObject(dict)

    # note: you can turn off column sorting by using the following
    #  @myTableView.unbind("sortDescriptors")
  end

  def observeValueForKeyPath(keyPath, ofObject:object, change:change, context:context)
    NSLog("Table section changed: keyPath = %@, %@", keyPath, object.selectionIndexes)
  end

  def inspect(selectedObjects)
    # handle user double-click

    # this is an example of inspecting each selected object in the selection
    selectedObjects.count.times do |index|
      objectDict = selectedObjects.objectAtIndex(index)
      NSLog("inspect item: {%@ %@, %@}", objectDict.valueForKey("firstname"), objectDict.valueForKey("lastname"), objectDict.valueForKey("phone")) unless objectDict
    end

    # setup the edit sheet controller if one hasn't been setup already
    @myEditController ||= EditController.alloc.init

    # remember which selection index we are changing
    savedSelectionIndex = @myContentArray.selectionIndex

    # get the current selected object and start the edit sheet
    editItem = selectedObjects.objectAtIndex(0)
    newValues = @myEditController.edit(editItem, from:self)

    if !@myEditController.wasCancelled
      # remove the current selection and replace it with the newly edited one
      selectedObjects = @myContentArray.selectedObjects
      @myContentArray.removeObjects(selectedObjects)

      # make sure to add the new entry at the same selection location as before
      @myContentArray.insertObject(newValues, atArrangedObjectIndex:savedSelectionIndex)
    end
  end

  def add(sender)
    @myEditController ||= EditController.alloc.init

    # ask our edit sheet for information on the record we want to add
    newValues = @myEditController.edit(nil, from:self)
    if !@myEditController.wasCancelled
      @myContentArray.addObject(newValues)
    end
  end

  def remove(sender)
    @myContentArray.removeObjectAtArrangedObjectIndex(@myContentArray.selectionIndex)
  end

end