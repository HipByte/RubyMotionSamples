class MainActivity < Android::App::Activity

  def onCreate(savedInstanceState)
    super

    @list = Android::Widget::ListView.new(self)
    @list.setAdapter(adapter)

    self.contentView = @list
  end

  def adapter
    Android::Widget::ArrayAdapter.new(self, Android::R::Layout::Simple_list_item_1, States.all)
  end

end
