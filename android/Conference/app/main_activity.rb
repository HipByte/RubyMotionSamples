class MainActivity < Android::App::Activity
  MenuTitles = [
    'Schedule (day 1)',
    'Schedule (day 2)',
    'Venue',
    'Sponsors',
    'About'
  ]

  MenuPosition = 'MenuPosition'

  def onCreate(savedInstanceState)
    super

    # Create the content layout, which will be holding the content view. Assign a unique ID to the view that will be used in #selectItem to switch fragments.
    @contentLayout = Android::Widget::FrameLayout.new(self)
    @contentLayout.setId(Android::View::View.generateViewId)

    # Create the drawer list view, which will be displaying the drawer menu titles.
    @drawerList = Android::Widget::ListView.new(self)
    @drawerList.adapter = Android::Widget::ArrayAdapter.new(self, Android::R::Layout::Simple_list_item_1, MenuTitles)
    @drawerList.choiceMode = Android::Widget::AbsListView::CHOICE_MODE_SINGLE
    @drawerList.dividerHeight = 0
    @drawerList.backgroundColor = Android::Graphics::Color.rgb(1, 1, 1)
    @drawerList.onItemClickListener = self

    # Create the drawer layout, which will be the activity's main view. The first subview must be the drawer content view and the second the drawer menu list view.
    @drawerLayout = Android::Support::V4::Widget::DrawerLayout.new(self)
    @drawerLayout.addView(@contentLayout, Android::Support::V4::Widget::DrawerLayout::LayoutParams.new(Android::View::ViewGroup::LayoutParams::MATCH_PARENT, Android::View::ViewGroup::LayoutParams::MATCH_PARENT))
    @drawerLayout.addView(@drawerList, Android::Support::V4::Widget::DrawerLayout::LayoutParams.new(240 * density, Android::View::ViewGroup::LayoutParams::MATCH_PARENT, Android::View::Gravity::START))
    self.contentView = @drawerLayout

    # Enable the action bar app icon to behave as a drawer toggle action.
    actionBar.displayHomeAsUpEnabled = true
    actionBar.homeButtonEnabled = true

    # Create the drawer toggler.
    @drawerToggle = Android::Support::V4::App::ActionBarDrawerToggle.new(self, @drawerLayout, resources.getIdentifier('ic_drawer', 'drawable', packageName), resources.getIdentifier('drawer_open', 'string', packageName), resources.getIdentifier('drawer_close', 'string', packageName))
    @drawerLayout.drawerListener = @drawerToggle

    @fragments = [nil, nil, nil, nil, nil, nil]
    selectItem(0) unless savedInstanceState
  end

  # Called when the action bar app icon is selected.
  def onOptionsItemSelected(item)
    # Toggle the drawer.
    if @drawerToggle.onOptionsItemSelected(item)
      true
    else
      super
    end
  end

  # Called when the activity start-up is complete.
  def onPostCreate(savedInstanceState)
    super
    # Sync the drawer toggle state.
    @drawerToggle.syncState
  end

  # Called when the device configuration changes.
  def onConfigurationChanged(newConfig)
    super
    # Forward the new configuration to the drawer toggle.
    @drawerToggle.onConfigurationChanged(newConfig)
  end

  # Called when one of the drawer list items is selected.
  def onItemClick(parent, view, position, id)
    selectItem(position)
  end

  def selectItem(pos)
    # Create the view Fragment object if it does not exist already.
    @fragments[pos] ||= begin
      klass = case pos
        when 0, 1
          ScheduleFragment
        when 2
          VenueFragment
        when 3
          SponsorsFragment
        when 4
          AboutFragment
      end
      fragment = klass.new
      args = Android::Os::Bundle.new
      args.putInt(MenuPosition, pos)
      fragment.arguments = args
      fragment
    end

    # Replace the content layout view with the selected fragment.
    fragmentManager.beginTransaction.replace(@contentLayout.getId, @fragments[pos]).commit

    # Refresh the action bar title and close the drawer.
    self.title = MenuTitles[pos]
    @drawerLayout.closeDrawer(@drawerList)
  end

  def density
    @density ||= resources.displayMetrics.density
  end
end
