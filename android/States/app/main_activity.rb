class MainActivity < Android::App::Activity

  def onCreate(savedInstanceState)
    super

    list = Android::Widget::ListView.new(self)
    list.adapter = adapter
    list.onItemSelectedListener = self

    self.contentView = list
  end

  def adapter
    Android::Widget::ArrayAdapter.new(self, Android::R::Layout::Simple_list_item_1, States.all)
  end

  def onItemSelected(parent, view, position, id)
    puts 'clicked'
  end

end
