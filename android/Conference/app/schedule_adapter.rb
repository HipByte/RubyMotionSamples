class ScheduleAdapter < Android::Widget::ArrayAdapter
  def schedule=(schedule)
    @schedule = schedule
  end

  # Instead of a generic TextView, we return a custom view for each schedule item.
  def getView(position, convertView, parent)
    titleTextView = Android::Widget::TextView.new(context)
    titleTextView.text = @schedule[position][:title]
    titleTextView.textSize = 20.0
    titleTextView.setTypeface(nil, Android::Graphics::Typeface::BOLD)
    titleTextView.textColor = Android::Graphics::Color::BLACK

    whenTextView = Android::Widget::TextView.new(context)
    whenTextView.text = @schedule[position][:when]
    whenTextView.textSize = 16.0
    whenTextView.textColor = Android::Graphics::Color::BLACK
    whenTextView.gravity = Android::View::Gravity::CENTER_VERTICAL

    whoTextView = nil
    if who = @schedule[position][:who]
      whoTextView = Android::Widget::TextView.new(context)
      whoTextView.text = who
      whoTextView.textSize = 16.0
      whoTextView.textColor = Android::Graphics::Color::BLACK
    else
      titleTextView.gravity = Android::View::Gravity::CENTER_VERTICAL
    end

    rightView = nil
    rightViewHeight = -1
    if whoTextView
      rightView = Android::Widget::LinearLayout.new(context)
      rightView.orientation = Android::Widget::LinearLayout::VERTICAL
      rightView.addView(titleTextView)
      rightView.addView(whoTextView)
    else
      rightView = titleTextView
      rightViewHeight = 65 * context.density
    end

    whenTextView.setPadding(10 * context.density, 10, 10, 10)
    rightView.setPadding(0, 10, 10, 10)

    layout2 = Android::Widget::LinearLayout.new(context)
    layout2.orientation = Android::Widget::LinearLayout::HORIZONTAL
    layout2.addView(whenTextView, 85 * context.density, -1)
    layout2.addView(rightView, -1, rightViewHeight)
    layout2
  end
end
