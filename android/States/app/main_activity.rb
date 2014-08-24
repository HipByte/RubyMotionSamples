class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    list = Android::Widget::ListView.new(self)
    list.adapter = adapter
    list.onItemClickListener = self
    self.contentView = list
  end

  def adapter
    Android::Widget::ArrayAdapter.new(self, Android::R::Layout::Simple_list_item_1, States.all)
  end

  def onItemClick(parent, view, position, id)
    selected_state = States.all[position]
    puts "Clicked #{selected_state}"

    intent = Android::Content::Intent.new(self, WikipediaActivity)
    intent.putExtra(WikipediaActivity::SelectedState, selected_state)
    startActivity(intent)
  end
end
