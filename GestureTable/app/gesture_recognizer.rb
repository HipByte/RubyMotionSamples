class GestureRecognizer
  CommitEditingRowDefaultRowHeight = 80
  RowAnimationDuration = 0.25
  CellSnapshotTag = 100000

  def init_with_table_view(tableView, delegate:delegate)
    if init
      @tableView = tableView
      @delegate=  delegate
      @state = :none
      @tableViewDelegate = tableView.delegate
      tableView.delegate = self
    
      @pinchRecognizer = UIPinchGestureRecognizer.alloc.initWithTarget(self, action: :"pinch_gesture_recognizer:")
      @panRecognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action: :"pan_gesture_recognizer:")
      @longPressRecognizer = UILongPressGestureRecognizer.alloc.initWithTarget(self, action: :"long_press_pesture_recognizer:")
      tableView.gestureRecognizers += [@pinchRecognizer, @panRecognizer, @longPressRecognizer]
      @pinchRecognizer.delegate = @panRecognizer.delegate = @longPressRecognizer.delegate = self
      @addingRowHeight = 0
    end
    self
  end

  def scroll_table
    location = @longPressRecognizer.locationInView(@tableView)

    currentOffset = @tableView.contentOffset
    @scrollingRate ||= 0
    newOffset = CGPointMake(currentOffset.x, currentOffset.y + @scrollingRate)
    if newOffset.y < 0
      newOffset.y = 0
    elsif @tableView.contentSize.height < @tableView.frame.size.height
      newOffset = currentOffset
    elsif newOffset.y > @tableView.contentSize.height - @tableView.frame.size.height
      newOffset.y = @tableView.contentSize.height - @tableView.frame.size.height
    end
    @tableView.setContentOffset(newOffset)

    if location.y >= 0
      cellSnapshotView = @tableView.viewWithTag(CellSnapshotTag)
      cellSnapshotView.center = CGPointMake(@tableView.center.x, location.y)
    end

    update_adding_index_path_for_current_location
  end

  def update_adding_index_path_for_current_location
    indexPath = index_path_from_recognizer(@longPressRecognizer)
    if indexPath && indexPath != @addingIndexPath
      @tableView.beginUpdates
      @tableView.deleteRowsAtIndexPaths([@addingIndexPath], withRowAnimation: UITableViewRowAnimationNone)
      @tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationNone)
      @delegate.gesture_recognizer(self, needsMoveRowAtIndexPath: @addingIndexPath, toIndexPath: indexPath)
      @tableView.endUpdates 
      @addingIndexPath = indexPath
    end
  end

  def commit_or_discard_cell
    @tableView.beginUpdates

    cell = @tableView.cellForRowAtIndexPath(@addingIndexPath)
    commitingCellHeight =
      if @delegate.respond_to? :"gesture_recognizer:heightForCommittingRowAtIndexPath:"
        @delegate.gesture_recognizer(self, heightForCommittingRowAtIndexPath: @addingIndexPath)
      else
        @tableView.rowHeight
      end
    if cell.frame.size.height >= commitingCellHeight
      @delegate.gesture_recognizer(self, needsCommitRowAtIndexPath: @addingIndexPath)
    else
      @delegate.gesture_recognizer(self, needsDiscardRowAtIndexPath: @addingIndexPath)
      @tableView.deleteRowsAtIndexPaths([@addingIndexPath], withRowAnimation: UITableViewRowAnimationMiddle)
    end

    @tableView.performSelector(:"reload_visible_rows_except_index_path:", withObject: @addingIndexPath, afterDelay: RowAnimationDuration)
    @addingIndexPath = nil

    @tableView.endUpdates

    UIView.beginAnimations('', context: nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(0.5)
    @tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    UIView.commitAnimations

    @state = :none
  end

  def pinch_gesture_recognizer(recognizer)
    if recognizer.state == UIGestureRecognizerStateEnded || recognizer.numberOfTouches < 2
      self.commit_or_discard_cell if @addingIndexPath
      return
    end

    location1 = recognizer.locationOfTouch(0, inView: @tableView)
    location2 = recognizer.locationOfTouch(1, inView: @tableView)
    upperPoint = location1.y < location2.y ? location1 : location2

    rect = CGRectMake(*location1, location2.x - location1.x, location2.y - location1.y)

    if recognizer.state == UIGestureRecognizerStateBegan
      @state = :pinching
      indexPaths = @tableView.indexPathsForRowsInRect(rect)
      unless indexPaths.empty?
        midIndex = ((indexPaths.first.row + indexPaths.last.row) / 2.0) + 0.5
        midIndexPath = NSIndexPath.indexPathForRow(midIndex, inSection: indexPaths.first.section)

        @startPinchingUpperPoint = upperPoint

        if @delegate.respond_to? :"gesture_recognizer:will_create_cell_at_index_path:"
          @addingIndexPath = @delegate.gesture_recognizer(self, will_create_cell_at_index_path: midIndexPath)
        else
          @addingIndexPath = midIndexPath
        end

        @tableView.contentInset = UIEdgeInsetsMake(@tableView.frame.size.height, 0, @tableView.frame.size.height, 0)

        if @addingIndexPath
          @tableView.beginUpdates
          @delegate.gesture_recognizer(self, needsAddRowAtIndexPath: @addingIndexPath)
          @tableView.insertRowsAtIndexPaths([@addingIndexPath], withRowAnimation: UITableViewRowAnimationMiddle)
          @tableView.endUpdates
        end
      end
    elsif recognizer.state == UIGestureRecognizerStateChanged
      diffRowHeight = CGRectGetHeight(rect) - CGRectGetHeight(rect)/recognizer.scale
      if @addingRowHeight - diffRowHeight >= 1 || @addingRowHeight - diffRowHeight <= -1
        @addingRowHeight = diffRowHeight
        @tableView.reloadData
      end

      newUpperPoint = upperPoint
      diffOffsetY = @startPinchingUpperPoint.y - newUpperPoint.y
      newOffset = CGPointMake(@tableView.contentOffset.x, @tableView.contentOffset.y + diffOffsetY)
      @tableView.setContentOffset(newOffset, animated: false)
    end
  end

  def pan_gesture_recognizer(recognizer)
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) &&
        recognizer.numberOfTouches > 0

      location1 = recognizer.locationOfTouch(0, inView: @tableView)
      indexPath = @addingIndexPath
      unless indexPath
        indexPath = @tableView.indexPathForRowAtPoint(location1)
        @addingIndexPath = indexPath
      end

      @state = :panning
      cell = @tableView.cellForRowAtIndexPath(indexPath)
      translation = recognizer.translationInView(@tableView)
      cell.contentView.frame = CGRectOffset(cell.contentView.bounds, translation.x, 0)

      if @delegate.respond_to? :"gesture_recognizer:didChangeContentViewTranslation:forRowAtIndexPath:"
        @delegate.gesture_recognizer(self, didChangeContentViewTranslation: translation, forRowAtIndexPath: indexPath)
      end

      commitEditingLength = length_for_commit_editing_row_at_index_path(indexPath)
      if translation.x.abs >= commitEditingLength
        if @addingCellState == :middle
          @addingCellState = translation.x > 0 ? :right : :left
        end
      else
        if @addingCellState != :middle
          @addingCellState = :middle
        end
      end

      if @delegate.respond_to? :"gesture_recognizer:didEnterEditingState:forRowAtIndexPath:"
        @delegate.gesture_recognizer(self, didEnterEditingState: @addingCellState, forRowAtIndexPath: indexPath)
      end
    elsif recognizer.state == UIGestureRecognizerStateEnded
      cell = @tableView.cellForRowAtIndexPath(@addingIndexPath)
      translation = recognizer.translationInView(@tableView)

      commitEditingLength = length_for_commit_editing_row_at_index_path(@addingIndexPath)
      if translation.x.abs >= commitEditingLength
        if @delegate.respond_to? :"gesture_recognizer:commitEditingState:forRowAtIndexPath:"
          @delegate.gesture_recognizer(self, commitEditingState: @addingCellState, forRowAtIndexPath: @addingIndexPath)
        end
      else
        UIView.beginAnimations('', context: nil)
        cell.contentView.frame = cell.contentView.bounds
        UIView.commitAnimations
      end

      @addingCellState = :middle
      @addingIndexPath = nil
      @state = :none
    end
  end

  def long_press_pesture_recognizer(recognizer)
    location = recognizer.locationInView(@tableView)
    indexPath = index_path_from_recognizer(recognizer)

    case recognizer.state
    when UIGestureRecognizerStateBegan
      @state = :moving

      cell = @tableView.cellForRowAtIndexPath(indexPath)
      UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
      cell.layer.renderInContext(UIGraphicsGetCurrentContext())
      cellImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      snapShotView = @tableView.viewWithTag(CellSnapshotTag)
      unless snapShotView
        snapShotView = UIImageView.alloc.initWithImage(cellImage)
        snapShotView.tag = CellSnapshotTag
        @tableView.addSubview(snapShotView)
        rect = @tableView.rectForRowAtIndexPath(indexPath)
        snapShotView.frame = CGRectOffset(snapShotView.bounds, rect.origin.x, rect.origin.y)
      end

      UIView.beginAnimations('zoomCell', context: nil)
      snapShotView.transform = CGAffineTransformMakeScale(1.1, 1.1)
      snapShotView.center = CGPointMake(@tableView.center.x, location.y)
      UIView.commitAnimations

      @tableView.beginUpdates
      @tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationNone)
      @tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationNone)
      @delegate.gesture_recognizer(self, needsCreatePlaceholderForRowAtIndexPath: indexPath)
      @addingIndexPath = indexPath
      @tableView.endUpdates

      @movingTimer = NSTimer.timerWithTimeInterval((1/8.0), target: self, selector: :scroll_table, userInfo: nil, repeats: true)
      NSRunLoop.mainRunLoop.addTimer(@movingTimer, forMode: NSDefaultRunLoopMode)

    when UIGestureRecognizerStateEnded
      snapShotView = @tableView.viewWithTag(CellSnapshotTag)
      indexPath = @addingIndexPath

      @movingTimer.invalidate
      @movingTimer = nil
      @scrollingRate = 0

      UIView.animateWithDuration(RowAnimationDuration,
          animations: -> do
            rect = @tableView.rectForRowAtIndexPath(indexPath)
            snapShotView.transform = CGAffineTransformIdentity
            snapShotView.frame = CGRectOffset(snapShotView.bounds, rect.origin.x, rect.origin.y)
          end,
          completion: ->(finished) do
            snapShotView.removeFromSuperview

            @tableView.beginUpdates
            @tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationNone)
            @tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationNone)
            @delegate.gesture_recognizer(self, needsReplacePlaceholderForRowAtIndexPath: indexPath)
            @tableView.endUpdates

            @tableView.reload_visible_rows_except_index_path(indexPath)
            @cellSnapshot = nil
            @addingIndexPath = nil
            @state = :none
          end)

    when UIGestureRecognizerStateChanged
      snapShotView = @tableView.viewWithTag(CellSnapshotTag)
      snapShotView.center = CGPointMake(@tableView.center.x, location.y)

      rect = @tableView.bounds
      location = @longPressRecognizer.locationInView(@tableView)
      location.y -= @tableView.contentOffset.y

      self.update_adding_index_path_for_current_location

      topDropZoneHeight = bottomDropZoneHeight = @tableView.bounds.size.height / 6.0
      bottomDiff = location.y - (rect.size.height - bottomDropZoneHeight)
      if bottomDiff > 0
        @scrollingRate = bottomDiff / (bottomDropZoneHeight / 1)
      elsif location.y <= topDropZoneHeight
        @scrollingRate = -(topDropZoneHeight - [location.y, 0].max) / bottomDropZoneHeight
      else
        @scrollingRate = 0
      end
    end
  end

  def gestureRecognizerShouldBegin(gestureRecognizer)
    indexPath = index_path_from_recognizer(gestureRecognizer)

    case gestureRecognizer
    when @panRecognizer
      point = gestureRecognizer.translationInView(@tableView)
      if point.y.abs > point.x.abs || indexPath.nil?
        false
      elsif indexPath
        @delegate.gesture_recognizer(self, canEditRowAtIndexPath: indexPath)
      end
    when @longPressRecognizer
      if indexPath
        @delegate.gesture_recognizer(self, canMoveRowAtIndexPath: indexPath)
      else
        false
      end
    else
      true
    end
  end

  def tableView(aTableView, heightForRowAtIndexPath: indexPath)
    if indexPath == @addingIndexPath && (@state == :pinching || @state == :dragging)
      [1, @addingRowHeight || 0].max
    else
      @tableViewDelegate.tableView(aTableView, heightForRowAtIndexPath: indexPath)
    end
  end

  def scrollViewDidScroll(scrollView)
    if scrollView.contentOffset.y < 0
      if @addingIndexPath.nil? && @state == :none && !scrollView.isDecelerating
        @state = :dragging
        @addingIndexPath = 
          if @delegate.respond_to?(:"gesture_recognizer:will_create_cell_at_index_path:")
            @delegate.gesture_recognizer(self, will_create_cell_at_index_path: @addingIndexPath)
          else
            NSIndexPath.indexPathForRow(0, inSection: 0)
          end

        @tableView.beginUpdates
        @delegate.gesture_recognizer(self, needsAddRowAtIndexPath: @addingIndexPath)
        @tableView.insertRowsAtIndexPaths([@addingIndexPath], withRowAnimation: UITableViewRowAnimationNone)
        @addingRowHeight = scrollView.contentOffset.y.abs
        @tableView.endUpdates
      end
    end

    if @state == :dragging
      @addingRowHeight += scrollView.contentOffset.y * -1
      @tableView.reloadData
      scrollView.setContentOffset(CGPointZero)
    end
  end

  def scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    if @state == :dragging
      @state = :none
      self.commit_or_discard_cell
    end
  end

  def index_path_from_recognizer(recognizer)
    location = recognizer.locationInView(@tableView)
    @tableView.indexPathForRowAtPoint(location)
  end

  def length_for_commit_editing_row_at_index_path(indexPath)
    if @delegate.respond_to? :"gesture_recognizer:length_for_commit_editing_row_at_index_path:"
      @delegate.gesture_recognizer(self, length_for_commit_editing_row_at_index_path: indexPath)
    else
      CommitEditingRowDefaultRowHeight
    end
  end
end

