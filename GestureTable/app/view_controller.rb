class ViewController < UITableViewController
  AddingCell = 'Continue...'
  DoneCell = 'Done'
  DummyCell = 'Dummy'
  CommittingCreateCellHeight = 60
  NormalCellFinishingHeight = 60

  def loadView
    self.tableView = UITableView.new

    @rows = ['Swipe to the right to complete', 'Swipe to left to delete', 'Drag down to create a new cell', 'Pinch two rows apart to create cell', 'Long hold to start reorder cell']
    @grabbedObject = nil
    @tableViewRecognizer = GestureRecognizer.alloc.initWithTableView(self.tableView, delegate:self)
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:false)
  end

  def viewDidLoad
    tableView.backgroundColor = UIColor.blackColor
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    tableView.rowHeight = NormalCellFinishingHeight
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @rows.count
  end

  def tableView(tableView, heightForRowAtIndexPath: indexPath)
    NormalCellFinishingHeight
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    object = @rows[indexPath.row]
    backgroundColor = backgroundColorForIndexPath(indexPath)

    if object == AddingCell
      if indexPath.row == 0
        cellIdentifier = 'PullDownTableViewCell'
        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        unless cell
          cell = TransformableTableViewCell.transformableTableViewCellWithStyle(:pullDown, reuseIdentifier: cellIdentifier)
          cell.textLabel.adjustsFontSizeToFitWidth = true
          cell.textLabel.textColor = UIColor.whiteColor
          cell.textLabel.textAlignment = UITextAlignmentCenter
        end

        cell.tintColor = backgroundColor
        cell.finishedHeight = CommittingCreateCellHeight
        cell.textLabel.text = cell.frame.size.height > CommittingCreateCellHeight ? 'Release to create cell...' : 'Continue Pulling...'
        cell.contentView.backgroundColor = UIColor.clearColor
      else
        cellIdentifier = 'UnfoldingTableViewCell'
        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        unless cell
          cell = TransformableTableViewCell.transformableTableViewCellWithStyle(:unfolding, reuseIdentifier: cellIdentifier)
          cell.textLabel.adjustsFontSizeToFitWidth = true
          cell.textLabel.textColor = UIColor.whiteColor
          cell.textLabel.textAlignment = UITextAlignmentCenter
        end

        cell.tintColor = backgroundColor
        cell.finishedHeight = CommittingCreateCellHeight
        cell.textLabel.text = cell.frame.size.height > CommittingCreateCellHeight ? 'Release to create cell...' : 'Continue Pinching...'
        cell.contentView.backgroundColor = UIColor.clearColor
        cell.detailTextLabel.text = ' '
      end
    else
      cellIdentifier = 'MyCell'
      cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
      unless cell
        cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: cellIdentifier)
        cell.textLabel.adjustsFontSizeToFitWidth = true
        cell.textLabel.backgroundColor = UIColor.clearColor
        cell.selectionStyle = UITableViewCellSelectionStyleNone
      end

      text = object.to_s
      textColor = UIColor.whiteColor
      if object == DoneCell
        textColor = UIColor.grayColor
        backgroundColor = UIColor.darkGrayColor
      elsif object == DummyCell
        text = ''
        backgroundColor = UIColor.clearColor
      end

      cell.textLabel.text = text
      cell.textLabel.textColor = textColor
      cell.contentView.backgroundColor = backgroundColor
    end

    cell
  end

  def gestureRecognizer(gestureRecognizer, needsAddRowAtIndexPath: indexPath)
    @rows.insert(indexPath.row, AddingCell)
  end

  def gestureRecognizer(gestureRecognizer, needsCommitRowAtIndexPath: indexPath)
    @rows[indexPath.row] = 'Added!'
    cell = tableView.cellForRowAtIndexPath(indexPath)
    cell.finishedHeight = NormalCellFinishingHeight
    cell.textLabel.text = 'Just Added!'
  end

  def gestureRecognizer(gestureRecognizer, needsDiscardRowAtIndexPath: indexPath)
    @rows.delete_at(indexPath.row)
  end

  def gestureRecognizer(gestureRecognizer, didEnterEditingState: state, forRowAtIndexPath: indexPath)
    backgroundColor = case state
      when :middle
        backgroundColorForIndexPath(indexPath)
      when :right
        UIColor.greenColor
      else
        UIColor.darkGrayColor
      end

    cell = tableView.cellForRowAtIndexPath(indexPath)
    cell.contentView.backgroundColor = backgroundColor
    cell.tintColor = backgroundColor if cell.kind_of? TransformableTableViewCell
  end

  def gestureRecognizer(gestureRecognizer, canEditRowAtIndexPath: indexPath)
    true
  end

  def gestureRecognizer(gestureRecognizer, commitEditingState: state, forRowAtIndexPath: indexPath)
    tableView.beginUpdates
    case state
    when :left
      @rows.delete_at(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationLeft)
    when :right
      @rows[indexPath.row] = DoneCell
      tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimationLeft)
    end
    tableView.endUpdates

    tableView.performSelector(:"reloadVisibleRowsExceptIndexPath:", withObject: indexPath, afterDelay: GestureRecognizer::RowAnimationDuration)
  end

  def gestureRecognizer(gestureRecognizer, canMoveRowAtIndexPath: indexPath)
    true
  end

  def gestureRecognizer(gestureRecognizer, needsCreatePlaceholderForRowAtIndexPath: indexPath)
    @grabbedObject = @rows[indexPath.row]
    @rows[indexPath.row] = DummyCell
  end

  def gestureRecognizer(gestureRecognizer, needsMoveRowAtIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
    object = @rows[sourceIndexPath.row]
    @rows.delete_at(sourceIndexPath.row)
    @rows.insert(destinationIndexPath.row, object)
  end

  def gestureRecognizer(gestureRecognizer, needsReplacePlaceholderForRowAtIndexPath: indexPath)
    @rows[indexPath.row] = @grabbedObject
    @grabbedObject = nil
  end

  def backgroundColorForIndexPath(indexPath)
    UIColor.redColor.colorWithHueOffset(0.12 * indexPath.row / @rows.count)
  end
end
