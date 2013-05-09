class Location < NSManagedObject
  def self.entity
    @entity ||= begin
      # Create the entity for our Location class. The entity has 3 properties. CoreData will appropriately define accessor methods for the properties.
      entity = NSEntityDescription.alloc.init
      entity.name = 'Location'
      entity.managedObjectClassName = 'Location'
      entity.properties = 
        ['creation_date', NSDateAttributeType,
         'latitude', NSDoubleAttributeType,
         'longitude', NSDoubleAttributeType].each_slice(2).map do |name, type|
            property = NSAttributeDescription.alloc.init
            property.name = name
            property.attributeType = type
            property.optional = false
            property
          end
      entity
    end
  end 
end
