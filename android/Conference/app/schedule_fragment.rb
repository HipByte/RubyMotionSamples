class ScheduleFragment < Android::App::Fragment
  ScheduleDay1 = [
    { :title => "Registration & Breakfast",
      :when => "8:30am" },
    { :title => "RubyMotion State of the Union",
      :when => "9:30am",
      :who => "Laurent Sansonetti, Shizuo Fujita, Eloy Duran" },
    { :title => "Going Pro with RubyMotion",
      :when => "10:45am",
      :who => "Jamon Holmgren" },
    { :title => "UnderOS, Native iOS for Web-Developers",
      :when => "11:20am",
      :who => "Nikolay Nemshilov" },
    { :title => "What's new in RMQ (RubyMotionQuery)",
      :when => "12:55am",
      :who => "Todd Werth" },
    { :title => "Lunch",
      :when => "12:30pm" },
    { :title => "RubyMotion in Production (Panel)",
      :when => "2:00pm" },
    { :title => "App Promotion: Strategy and Execution",
      :when => "2:35pm",
      :who => "Mark Rickert" },
    { :title => "Test Driven Motion",
      :when => "3:30pm",
      :who => "Andy Pliszka" },
    { :title => "Testing RubyMotion Applications using Appium",
      :when => "4:05pm",
      :who => "Isaac Murchie" },
    { :title => "CoreData & RubyMotion",
      :when => "5:00pm",
      :who => "Lori Olson" },
    { :title => "What's new in CoreDataQuery (CDQ)",
      :when => "5:35pm",
      :who => "Ken Miller" },
    { :title => "Closing",
      :when => "6:00pm" },
    { :title => "CocoaKucha",
      :when => "8:00pm" }
  ]

  ScheduleDay2 = [
    { :title => "Registration & Breakfast",
      :when => "8:30am" },
    { :title => "Making RubyMotion Better",
      :when => "9:15am",
      :who => "Jack Watson-Hamblin" },
    { :title => "Don't Let the Cocoa API Crush Your Ruby Code",
      :when => "9:50am",
      :who => "Alex Rothenberg" },
    { :title => "Reactive RubyMotion",
      :when => "10:45am",
      :who => "Dave Lee" },
    { :title => "Building Apps that Builds Apps",
      :when => "11:20am",
      :who => "Clay Allsopp" },
    { :title => "What's new in Pixate",
      :when => "11:55am",
      :who => "Paul Colton" },
    { :title => "Lunch",
      :when => "12:30pm" },
    { :title => "RubyMotion and Accessibility",
      :when => "2:00pm",
      :who => "Austin Seraphin" },
    { :title => "Getting Started with AVFoundation",
      :when => "2:35pm",
      :who => "Ivan Acosta-Rubio" },
    { :title => "SkFun: SpriteKit and RubyMotion",
      :when => "3:30pm",
      :who => "Will Raxworthy" },
    { :title => "Connecting RubyMotion",
      :when => "4:05pm",
      :who => "Mark Villacampa" },
    { :title => "Connecting RubyMotion to Enterprise Systems",
      :when => "5:00pm",
      :who => "Kevin Poorman" },
    { :title => "RubyMine and RubyMotion",
      :when => "5:35pm",
      :who => "Dennis Ushakov" },
    { :title => "Closing",
      :when => "6:00pm" },
    { :title => "Party!",
      :when => "8:00pm" }
  ]

  def onCreateView(inflater, container, savedInstanceState)
    @view ||= begin
      # Retrieve the item position from the arguments. We use it to determine which schedule day we need to display.
      pos = arguments.getInt(MainActivity::MenuPosition)

      # Create the list view with a custom adapter.
      view = Android::Widget::ListView.new(activity)
      schedule = pos == 0 ? ScheduleDay1 : ScheduleDay2
      view.adapter = ScheduleAdapter.new(activity, Android::R::Layout::Simple_list_item_1, schedule)
      view.adapter.schedule = schedule
      view.backgroundColor = Android::Graphics::Color::WHITE
      view.divider = Android::Graphics::Drawable::ColorDrawable.new(Android::Graphics::Color::BLACK)
      view.dividerHeight = 1
      view
    end
  end
end
