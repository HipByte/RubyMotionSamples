class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    layout = Android::Widget::LinearLayout.new(self)
    layout.orientation = Android::Widget::LinearLayout::VERTICAL
    layout.backgroundColor = Android::Graphics::Color.parseColor("#FF0099CC")

    @temperature_label = new_text_label
    @wind_direction_label = new_text_label
    @wind_speed_label = new_text_label

    layout.addView(@temperature_label)
    layout.addView(@wind_direction_label)
    layout.addView(@wind_speed_label)

    fetch_weather

    self.contentView = layout
  end

  def fetch_weather
    url = "http://www.bom.gov.au/fwo/IDN60901/IDN60901.94768.json"
    listener = RequestListener.new(self)
    get = Com::Android::Volley::Toolbox::JsonObjectRequest.new(VolleyMethods::GET, url, nil, listener, nil)

    request_queue.add(get)
  end

  def update_display(weather)
    @temperature_label.text = "Temp: #{weather.temp} celcius"
    @wind_direction_label.text = "Wind Direction: #{weather.wind_direction}"
    @wind_speed_label.text = "Wind Speed: #{weather.wind_speed} KM"
  end

  def request_queue
    @request_queue ||= Com::Android::Volley::Toolbox::Volley.newRequestQueue(self)
  end

  def new_text_label
    text = Android::Widget::TextView.new(self)
    text.textColor = Android::Graphics::Color::WHITE
    text.gravity = Android::View::Gravity::CENTER_HORIZONTAL
    text.textSize = 40.0
    text
  end
end
