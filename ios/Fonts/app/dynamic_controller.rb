
class DynamicController < UIViewController

  TEXT_STYLES = [
      UIFontTextStyleBody,
      UIFontTextStyleCallout,
      UIFontTextStyleCaption1,
      UIFontTextStyleCaption2,
      UIFontTextStyleFootnote,
      UIFontTextStyleHeadline,
      UIFontTextStyleSubheadline,
      UIFontTextStyleLargeTitle,
      UIFontTextStyleTitle1,
      UIFontTextStyleTitle2,
      UIFontTextStyleTitle3,
  ]

  def loadView
    self.view = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    view.backgroundColor = UIColor.whiteColor
    @labels = TEXT_STYLES.map do |style|
      label = UILabel.alloc.init
      view.addSubview(label)
      {:label => label, :style => style, size: UIFont.preferredFontForTextStyle(style).pointSize}
    end
  end

  def viewDidLoad
    navigationItem.title = "Dynamic Text - #{@font_name}"
  end

  def viewWillAppear(_)

    top = 100
    @labels.each do |label_style|
      metrics = UIFontMetrics.metricsForTextStyle(label_style[:style])
      label_style[:label].font = metrics.scaledFontForFont(UIFont.fontWithName(@font_name, size: label_style[:size]))
      label_style[:label].text = label_style[:style]
      label_style[:label].adjustsFontForContentSizeCategory = true

      label_style[:label].frame = [
          [10, top], [
          view.frame.size.width - 20, label_style[:label].font.pointSize + 5]
      ]
      top += label_style[:label].font.pointSize + 20
    end
  end

  def selected_font(font_name)
    @font_name = font_name
  end

end
