class UITableView
  def reloadVisibleRowsExceptIndexPath(indexPath)
    visibleRows = indexPathsForVisibleRows.mutableCopy
    visibleRows.removeObject(indexPath)
    reloadRowsAtIndexPaths(visibleRows, withRowAnimation: UITableViewRowAnimationNone)
  end
end
