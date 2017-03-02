class AppDelegate
  def buildMenu
    @mainMenu = NSMenu.new

    appName = NSBundle.mainBundle.infoDictionary['CFBundleName']
    addMenu(appName) do
      addItemWithTitle("About #{appName}", action: 'orderFrontStandardAboutPanel:', keyEquivalent: '')
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle('Preferences', action: 'openPreferences:', keyEquivalent: ',')
      addItem(NSMenuItem.separatorItem)
      servicesItem = addItemWithTitle('Services', action: nil, keyEquivalent: '')
      NSApp.servicesMenu = servicesItem.submenu = NSMenu.new
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle("Hide #{appName}", action: 'hide:', keyEquivalent: 'h')
      item = addItemWithTitle('Hide Others', action: 'hideOtherApplications:', keyEquivalent: 'H')
      item.keyEquivalentModifierMask = NSCommandKeyMask|NSAlternateKeyMask
      addItemWithTitle('Show All', action: 'unhideAllApplications:', keyEquivalent: '')
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle("Quit #{appName}", action: 'terminate:', keyEquivalent: 'q')
    end

    addMenu('File') do
      addItemWithTitle('New', action: 'newDocument:', keyEquivalent: 'n')
      addItemWithTitle('Open…', action: 'openDocument:', keyEquivalent: 'o')
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle('Close', action: 'performClose:', keyEquivalent: 'w')
      addItemWithTitle('Save…', action: 'saveDocument:', keyEquivalent: 's')
      addItemWithTitle('Revert to Saved', action: 'revertDocumentToSaved:', keyEquivalent: '')
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle('Page Setup…', action: 'runPageLayout:', keyEquivalent: 'P')
      addItemWithTitle('Print…', action: 'printDocument:', keyEquivalent: 'p')
    end

    addMenu('Edit') do
      addItemWithTitle('Undo', action: 'undo:', keyEquivalent: 'z')
      addItemWithTitle('Redo', action: 'redo:', keyEquivalent: 'Z')
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle('Cut', action: 'cut:', keyEquivalent: 'x')
      addItemWithTitle('Copy', action: 'copy:', keyEquivalent: 'c')
      addItemWithTitle('Paste', action: 'paste:', keyEquivalent: 'v')
      item = addItemWithTitle('Paste and Match Style', action: 'pasteAsPlainText:', keyEquivalent: 'V')
      item.keyEquivalentModifierMask = NSCommandKeyMask|NSAlternateKeyMask
      addItemWithTitle('Delete', action: 'delete:', keyEquivalent: '')
      addItemWithTitle('Select All', action: 'selectAll:', keyEquivalent: 'a')
    end

    fontMenu = createMenu('Font') do
      addItemWithTitle('Show Fonts', action: 'orderFrontFontPanel:', keyEquivalent: 't')
      addItemWithTitle('Bold', action: 'addFontTrait:', keyEquivalent: 'b')
      addItemWithTitle('Italic', action: 'addFontTrait:', keyEquivalent: 'i')
      addItemWithTitle('Underline', action: 'underline:', keyEquivalent: 'u')
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle('Bigger', action: 'modifyFont:', keyEquivalent: '+')
      addItemWithTitle('Smaller', action: 'modifyFont:', keyEquivalent: '-')
    end

    textMenu = createMenu('Text') do
      addItemWithTitle('Align Left', action: 'alignLeft:', keyEquivalent: '{')
      addItemWithTitle('Center', action: 'alignCenter:', keyEquivalent: '|')
      addItemWithTitle('Justify', action: 'alignJustified:', keyEquivalent: '')
      addItemWithTitle('Align Right', action: 'alignRight:', keyEquivalent: '}')
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle('Show Ruler', action: 'toggleRuler:', keyEquivalent: '')
      item = addItemWithTitle('Copy Ruler', action: 'copyRuler:', keyEquivalent: 'c')
      item.keyEquivalentModifierMask = NSCommandKeyMask|NSControlKeyMask
      item = addItemWithTitle('Paste Ruler', action: 'pasteRuler:', keyEquivalent: 'v')
      item.keyEquivalentModifierMask = NSCommandKeyMask|NSControlKeyMask
    end

    addMenu('Format') do
      addItem fontMenu
      addItem textMenu
    end

    addMenu('View') do
      item = addItemWithTitle('Show Toolbar', action: 'toggleToolbarShown:', keyEquivalent: 't')
      item.keyEquivalentModifierMask = NSCommandKeyMask|NSAlternateKeyMask
      addItemWithTitle('Customize Toolbar…', action: 'runToolbarCustomizationPalette:', keyEquivalent: '')
    end

    NSApp.windowsMenu = addMenu('Window') do
      addItemWithTitle('Minimize', action: 'performMiniaturize:', keyEquivalent: 'm')
      addItemWithTitle('Zoom', action: 'performZoom:', keyEquivalent: '')
      addItem(NSMenuItem.separatorItem)
      addItemWithTitle('Bring All To Front', action: 'arrangeInFront:', keyEquivalent: '')
    end.menu

    NSApp.helpMenu = addMenu('Help') do
      addItemWithTitle("#{appName} Help", action: 'showHelp:', keyEquivalent: '?')
    end.menu

    NSApp.mainMenu = @mainMenu
  end

  private

  def addMenu(title, &b)
    item = createMenu(title, &b)
    @mainMenu.addItem item
    item
  end

  def createMenu(title, &b)
    menu = NSMenu.alloc.initWithTitle(title)
    menu.instance_eval(&b) if b
    item = NSMenuItem.alloc.initWithTitle(title, action: nil, keyEquivalent: '')
    item.submenu = menu
    item
  end
end
