def retrieve_subview_with_tag(topview,tag)
  retval = topview.view.subviews.find { |v| v.tag == tag }
  retval ||= topview.view
end
