describe "The Timer view controller" do
  tests TimerController

  it "has a timer label" do
    view('Tap to start').should.not == nil
  end

  it "starts a timer" do
    tap 'Start'
    controller.timer.isValid.should == true
  end

  it "increases the timer label value" do
    label = view('Tap to start')
    label.text.to_f.should == 0

    tap 'Start'
    proper_wait 1
    tap 'Stop'
    label.text.to_f.should > 1
    label.text.to_f.should < 2
  end

  it "resets the timer on each run" do
    label = view('Tap to start')

    tap 'Start'
    proper_wait 1
    tap 'Stop'

    tap 'Start'
    tap 'Stop'

    label.text.to_f.should < 1
  end
end
