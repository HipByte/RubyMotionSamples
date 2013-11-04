class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.whiteColor

    label = UILabel.alloc.initWithFrame @window.frame
    label.textAlignment = UITextAlignmentCenter
    label.text = "Tap!"

    BubbleWrap::HTTP.get("http://www.geognos.com/api/en/countries/info/all.json") do |response|
      if response.ok?
        json = BubbleWrap::JSON.parse(response.body.to_str)
        @countries = json["Results"].values.map{|info| info["Name"]}
      end
    end

    label.whenTapped do
      label.text = @countries.sample
    end

    @window.addSubview(label)
    @window.makeKeyAndVisible
    true
  end
end
