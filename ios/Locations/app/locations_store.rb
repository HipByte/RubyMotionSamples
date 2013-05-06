class LocationsStore
  def self.shared
    # Our store is a singleton object.
    @shared ||= LocationsStore.new
  end

  def locations
    @locations ||= begin
      # Fetch all locations from the model, sorting by the creation date.
      request = NSFetchRequest.alloc.init
      request.entity = NSEntityDescription.entityForName('Location', inManagedObjectContext:@context)
      request.sortDescriptors = [NSSortDescriptor.alloc.initWithKey('creation_date', ascending:false)] 

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end

  def add_location
    # Yield a blank, newly created Location entity, then save the model.
    yield NSEntityDescription.insertNewObjectForEntityForName('Location', inManagedObjectContext:@context)
    save
  end

  def remove_location(location)
    # Delete the given entity, then save the model.
    @context.deleteObject(location)
    save
  end

  private

  def initialize
    # Create the model programmatically. Our model has only one entity, the Location class, and the data will be stored in a SQLite database, inside the application's Documents folder.
    model = NSManagedObjectModel.alloc.init
    model.entities = [Location.entity]

    store = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'Locations.sqlite'))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    context = NSManagedObjectContext.alloc.init
    context.persistentStoreCoordinator = store
    @context = context
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @locations = nil
  end
end
