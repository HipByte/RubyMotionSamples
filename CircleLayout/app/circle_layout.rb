class CircleLayout < UICollectionViewLayout
  ItemSize = 70.0

  def prepareLayout
    super
    size = collectionView.frame.size
    @cell_count = collectionView.numberOfItemsInSection(0)
    @center = CGPoint.new(size.width / 2.0, size.height / 2.0)
    @radius = [size.width, size.height].min / 2.5  
  end

  def collectionViewContentSize
    collectionView.frame.size
  end

  def layoutAttributesForItemAtIndexPath(path)
    UICollectionViewLayoutAttributes.layoutAttributesForCellWithIndexPath(path).tap do |obj|
      obj.size = [ItemSize, ItemSize]
      obj.center = [@center.x + @radius * Math.cos(2 * path.item * Math::PI / @cell_count), @center.y + @radius * Math.sin(2 * path.item * Math::PI / @cell_count)]
    end
  end  

  def layoutAttributesForElementsInRect(rect)
    (0...@cell_count).map { |i| layoutAttributesForItemAtIndexPath(NSIndexPath.indexPathForItem(i, inSection:0)) }
  end

  def prepareForCollectionViewUpdates(items)
    super
    
    @deletePaths = []
    @insertPaths = []
    
    items.each do |i|
      case i.updateAction
      when UICollectionUpdateActionDelete
        @deletePaths << i.indexPathBeforeUpdate
      when UICollectionUpdateActionInsert
        @insertPaths << i.indexPathAfterUpdate
      end
    end
  end

  def initialLayoutAttributesForAppearingItemAtIndexPath(path)
    attributes = super

    if attributes.nil? && @insertPaths.include?(path)
      attributes = layoutAttributesForItemAtIndexPath path
      
      attributes.alpha = 0.0
      attributes.center = CGPointMake(@center.x, @center.y)
    end
    
    attributes
  end


  def finalLayoutAttributesForDisappearingItemAtIndexPath(path)
    attributes = super

    if attributes.nil? && @deletePaths.include?(path)
      attributes = layoutAttributesForItemAtIndexPath path
      
      attributes.alpha = 0.0
      attributes.center = CGPointMake(@center.x, @center.y)
      attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0)
    end
    
    attributes
  end

end
