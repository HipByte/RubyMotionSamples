class LocationsController < UITableViewController
  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Locations'
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_location')

    # The Add button is disabled by default, and will be enabled once the location manager is ready to return the current location.
    navigationItem.rightBarButtonItem.enabled = false
    @location_manager ||= CLLocationManager.alloc.init.tap do |lm|
      lm.desiredAccuracy = KCLLocationAccuracyNearestTenMeters
      lm.startUpdatingLocation
      lm.delegate = self
    end
  end

  def add_location
    LocationsStore.shared.add_location do |location|
      # We set up our new Location object here.
      coordinate = @location_manager.location.coordinate
      location.creation_date = NSDate.date
      location.latitude = coordinate.latitude
      location.longitude = coordinate.longitude
    end
    view.reloadData
  end

  def tableView(tableView, numberOfRowsInSection:section)
    LocationsStore.shared.locations.size
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    location = LocationsStore.shared.locations[indexPath.row]

    @date_formatter ||= NSDateFormatter.alloc.init.tap do |df|
      df.timeStyle = NSDateFormatterMediumStyle
      df.dateStyle = NSDateFormatterMediumStyle
    end
    cell.textLabel.text = @date_formatter.stringFromDate(location.creation_date)
    cell.detailTextLabel.text = "%0.3f, %0.3f" % [location.latitude, location.longitude]
    cell
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    location = LocationsStore.shared.locations[indexPath.row]
    LocationsStore.shared.remove_location(location)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end

  def locationManager(manager, didUpdateToLocation:newLocation, fromLocation:oldLocation)
    navigationItem.rightBarButtonItem.enabled = true 
  end

  def locationManager(manager, didFailWithError:error)
    navigationItem.rightBarButtonItem.enabled = false
  end
end
