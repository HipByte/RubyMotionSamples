class MainActivity < Android::App::Activity

  def onCreate(savedInstanceState)
    super

    @list = Android::Widget::ListView.new(self)
    @list.setAdapter(adapter)

    self.contentView = @list
  end

  def states
    %w(
      Alabama
      Alaska
      Arizona
      Arkansas
      California
      Colorado
      Connecticut
      Delaware
      Florida
      Georgia
      Hawaii
      Idaho
      Illinois
      Indiana
      Iowa
      Kansas
      Kentucky
      Louisiana
      Maine
      Maryland
      Massachusetts
      Michigan
      Minnesota
      Mississippi
      Missouri
      Montana
      Nebraska
      Nevada
      New\ Hampshire
      New\ Jersey
      New\ Mexico
      New\ York
      North\ Carolina
      North\ Dakota
      Ohio
      Oklahoma
      Oregon
      Pennsylvania
      Rhode\ Island
      South\ Carolina
      South\ Dakota
      Tennessee
      Texas
      Utah
      Vermont
      Virginia
      Washington
      West\ Virginia
      Wisconsin
      Wyoming)
  end

  def adapter
    # 17367043 is Android::R.layout.simple_list_item_1
    # Calling Android::R.layout.simple_list_item_1 with RM 3.0 b0.3 results in:
    #
    # Exception raised: NoMethodError: undefined method `layout' for android.R:java.lang.Class
    #
    # Documentation of R.layout:
    # http://developer.android.com/reference/android/R.layout.html

    Android::Widget::ArrayAdapter.new(self, 17367043, states)
  end

end
