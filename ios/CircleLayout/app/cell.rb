class Cell < UICollectionViewCell
  def initWithFrame(frame)
    if super
      contentView.layer.tap do |obj|
        obj.cornerRadius = 35.0
        obj.borderWidth = 1.0
        obj.borderColor = UIColor.whiteColor.CGColor
      end
      contentView.backgroundColor = UIColor.underPageBackgroundColor
    end
    self
  end
end
