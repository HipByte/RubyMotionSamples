class ViewController < UICollectionViewController
  CellIdentifier = 'MyCell'

  def viewDidLoad
    @cell_count = 20
    tap = UITapGestureRecognizer.alloc.initWithTarget(self, action: :'handleTapGesture:')
    collectionView.addGestureRecognizer(tap)
    collectionView.registerClass(Cell, forCellWithReuseIdentifier:CellIdentifier)
    collectionView.backgroundColor = UIColor.scrollViewTexturedBackgroundColor
  end

  def collectionView(view, numberOfItemsInSection:section)
    @cell_count
  end

  def collectionView(view, cellForItemAtIndexPath:path)
    view.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath:path)
  end

  def handleTapGesture(sender)
    if sender.state == UIGestureRecognizerStateEnded
      pinch_point = sender.locationInView(collectionView)
      path = collectionView.indexPathForItemAtPoint(pinch_point)
      if path
        @cell_count -= 1
        collectionView.performBatchUpdates(lambda { collectionView.deleteItemsAtIndexPaths([path]) }, completion:nil)
      else
        @cell_count += 1
        collectionView.performBatchUpdates(lambda { collectionView.insertItemsAtIndexPaths([NSIndexPath.indexPathForItem(0, inSection:0)]) }, completion:nil)
      end
    end
  end
end
