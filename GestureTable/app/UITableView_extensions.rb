class UITableView
  def reload_visible_rows_except_index_path(indexPath)
    visibleRows = indexPathsForVisibleRows.mutableCopy
    visibleRows.removeObject(indexPath)
    reloadRowsAtIndexPaths(visibleRows, withRowAnimation: UITableViewRowAnimationNone)
  end
end
