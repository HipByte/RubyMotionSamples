class PeopleController

  def initialize window
    @imPersonStatus = []
    @abPeople = []

    scrollView = NSScrollView.alloc.initWithFrame window.contentView.bounds
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable
    scrollView.hasVerticalScroller = true
    window.contentView.addSubview scrollView

    @table = NSTableView.alloc.initWithFrame scrollView.bounds
    @table.delegate = self
    @table.dataSource = self

    column1 = NSTableColumn.alloc.initWithIdentifier 'status'
    column1.editable = false
    column1.headerCell.title = 'Status'
    column1.width = 40
    column1.dataCell = NSImageCell.alloc.init
    @table.addTableColumn column1
    
    column2 = NSTableColumn.alloc.initWithIdentifier 'name'
    column2.editable = false
    column2.headerCell.title = 'Name'
    column2.width = 250
    @table.addTableColumn column2

    scrollView.setDocumentView @table
    window.contentView.addSubview scrollView

    nCenter = NSNotificationCenter.defaultCenter
    nCenter.addObserver self,
      selector:'abDatabaseChangedExternallyNotification:',
      name:KABDatabaseChangedExternallyNotification,
      object:nil

    @serviceWatcher = ServiceWatcher.new
    @serviceWatcher.delegate = self
    @serviceWatcher.startMonitoring

    reloadABPeople
  end

  # Data Loading
  def bestStatusForPerson person
    bestStatus = IMPersonStatusOffline # Let's assume they're offline to start
    IMService.allServices.each do |service|
      snames = service.screenNamesForPerson person
      if snames
        snames.each do |screenName|
          dict = service.infoForScreenName screenName
          next if dict.nil?
          status = dict[IMPersonStatusKey]
          next if status.nil?
          thisStatus = status.intValue
          if thisStatus > bestStatus
            bestStatus = thisStatus 
          end
        end
      end
    end
    return bestStatus
  end

  # This dumps all the status information and rebuilds the array against the current @abPeople
  # Fairly expensive, so this is only done when necessary
  def rebuildStatusInformation
    @imPersonStatus = @abPeople.map { |person| bestStatusForPerson(person) }
    @table.reloadData
  end

  # Rebuild status information for a given person, much faster than a full rebuild
  def rebuildStatusInformationForPerson forPerson
    @abPeople.each_with_index do |person, i|
      next unless person == forPerson
      @imPersonStatus[i] = bestStatusForPerson(person)
    end
    @table.reloadData
  end
  
  # This will do a full flush of people in our AB Cache, along with rebuilding their status 
  def reloadABPeople
    @abPeople = ABAddressBook.sharedAddressBook.people.sort do |x, y|
      x.displayName <=> y.displayName
    end
    rebuildStatusInformation
  end

  # NSTableView Data Source

  def numberOfRowsInTableView tableView
    @abPeople ? @abPeople.size : 0
  end
  
  def tableView tableView, objectValueForTableColumn:tableColumn, row:row
    case tableColumn.identifier
      when 'status'
        status = @imPersonStatus[row]
        NSImage.imageNamed IMService.imageNameForStatus(status)
      when 'name'
        @abPeople[row].displayName
    end
  end

  # Notifications

  # If the AB database changes, force a reload of everyone
  # We could look in the notification to catch differential updates, but for now
  # this is fine.
  def abDatabaseChangedExternallyNotification notification
    reloadABPeople
  end

end