class EditController < NSWindowController
  attr_reader :window

  def init
    super
    buildPanel
    self
  end

  def buildPanel
    @window = NSPanel.alloc.initWithContentRect(NSMakeRect(0, 0, 275, 141),
      styleMask: NSTitledWindowMask|NSClosableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @window.title = "Edit"
    @window.setReleasedWhenClosed(false)

    @editForm = NSForm.alloc.initWithFrame(NSMakeRect(13, 48, 242, 73))
    @editForm.setAutoresizingMask(NSViewMaxYMargin|NSViewWidthSizable)
    @editForm.setCellSize(NSMakeSize(242, 19))
    editForm_first_cell = @editForm.addEntry("firstname")
    editForm_first_cell.setTitle("First:")
    editForm_last_cell = @editForm.addEntry("lastname")
    editForm_last_cell.setTitle("Last:")
    editForm_phone_cell = @editForm.addEntry("phone")
    editForm_phone_cell.setTitle("Phone:")
    @editForm.setKeyCell(editForm_first_cell)
    @editForm.setKeyCell(editForm_last_cell)
    @editForm.setKeyCell(editForm_phone_cell)
    @window.contentView.addSubview(@editForm)

    cancelButton = NSButton.alloc.initWithFrame(NSMakeRect(102, 13, 80, 28))
    cancelButton.setTitle("Cancel")
    cancelButton.setAction("cancel:")
    cancelButton.setTarget(self)
    cancelButton.setBezelStyle(NSRoundedBezelStyle)
    cancelButton.setAutoresizingMask(NSViewMinXMargin)
    @window.contentView.addSubview(cancelButton)

    okButton = NSButton.alloc.initWithFrame(NSMakeRect(180, 13, 80, 28))
    okButton.setTitle("OK")
    okButton.setAction("done:")
    okButton.setTarget(self)
    okButton.setBezelStyle(NSRoundedBezelStyle)
    okButton.setAutoresizingMask(NSViewMinXMargin)
    @window.contentView.addSubview(okButton)
  end

  def edit(startingValues, from:sender)
    window = self.window

    @cancelled = false

    editFields = @editForm.cells
    if startingValues != nil
      # we are editing current entry, use its values as the default
      @savedFields = startingValues

      editFields.objectAtIndex(0).setStringValue(startingValues.objectForKey("firstname"))
      editFields.objectAtIndex(1).setStringValue(startingValues.objectForKey("lastname"))
      editFields.objectAtIndex(2).setStringValue(startingValues.objectForKey("phone"))
    else
      # we are adding a new entry,
      # make sure the form fields are empty due to the fact that this controller is recycled
      # each time the user opens the sheet -
      editFields.objectAtIndex(0).setStringValue("")
      editFields.objectAtIndex(1).setStringValue("")
      editFields.objectAtIndex(2).setStringValue("")
    end

    NSApp.beginSheet(window, modalForWindow:sender.window, modalDelegate:nil, didEndSelector:nil, contextInfo:nil)
    NSApp.runModalForWindow(window)
    # sheet is up here...

    NSApp.endSheet(window)
    window.orderOut(self)

    @savedFields
  end

  def done(sender)
    # save the values for later
    editFields = @editForm.cells

    @savedFields = {
      "firstname" => editFields.objectAtIndex(0).stringValue,
      "lastname"  => editFields.objectAtIndex(1).stringValue,
      "phone"     => editFields.objectAtIndex(2).stringValue,
    }

    NSApp.stopModal
  end

  def cancel(sender)
    NSApp.stopModal
    @cancelled = true
  end

  def wasCancelled
    @cancelled
  end
end