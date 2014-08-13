class MainActivity < Android::App::Activity

  def onCreate(savedInstanceState)
    super

    @list = Android::Widget::ListView.new(self)
    @list.setAdapter(adapter)

    self.contentView = @list
  end

  def adapter
    # 17367043 is Android::R.layout.simple_list_item_1
    # Calling Android::R.layout.simple_list_item_1 with RM 3.0 b0.3 results in:
    #
    # Exception raised: NoMethodError: undefined method `layout' for android.R:java.lang.Class
    #
    # Documentation of R.layout:
    # http://developer.android.com/reference/android/R.layout.html

    Android::Widget::ArrayAdapter.new(self, 17367043, States.all)
  end

end
