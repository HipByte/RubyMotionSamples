def retrieveSubviewWithTag(topview,tag)
  retval = topview.view
  for subview in topview.view.subviews
    if subview.tag == tag
      retval = subview
    end
  end
  return retval
end
