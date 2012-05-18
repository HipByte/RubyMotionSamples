def retrieveSubviewWithTag(topview,tag)
  retval = topview.view.subviews.find { |v| v.tag == tag }
  retval ||= topview.view
end
