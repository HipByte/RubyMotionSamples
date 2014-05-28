class TransformableTableViewCell < UITableViewCell
  attr_accessor :finishedHeight

  def self.transformableTableViewCellWithStyle(style, reuseIdentifier: reuseIdentifier)
    case style
    when :pullDown
      PullDownTableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: reuseIdentifier)
    when :unfolding
      UnfoldingTableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: reuseIdentifier)
    else
      raise ArgumentError, "Style must be :pullDown or :unfolding"
    end
  end

  def tinyColor=(tinyColor)
    @tinyColor = tinyColor
  end

  def tinyColor
    @tinyColor
  end
end

class UnfoldingTableViewCell < TransformableTableViewCell
  def initWithStyle(style, reuseIdentifier: reuseIdentifier)
    if super
      transform = CATransform3DIdentity
      transform.m34 = -1 / 500.to_f
      contentView.layer.setSublayerTransform(transform)
  
      textLabel.layer.anchorPoint = CGPointMake(0.5, 0.0)
      detailTextLabel.layer.anchorPoint = CGPointMake(0.5, 1.0)
  
      textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight
      detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight
  
      self.selectionStyle = UITableViewCellSelectionStyleNone
      self.tintColor = UIColor.whiteColor
    end
    self
  end

  def layoutSubviews
    super

    fraction = self.frame.size.height / @finishedHeight.to_f
    fraction = [[1, fraction].min, 0].max

    angle = (Math::PI / 2) - Math.asin(fraction)
    transform = CATransform3DMakeRotation(angle, -1, 0, 0)
    textLabel.layer.setTransform(transform)
    detailTextLabel.layer.setTransform(CATransform3DMakeRotation(angle, 1, 0, 0))

    textLabel.backgroundColor = @tintColor.colorWithBrightness(0.3 + 0.7*fraction)
    detailTextLabel.backgroundColor = @tintColor.colorWithBrightness(0.5 + 0.5*fraction)

    contentViewSize = contentView.frame.size
    contentViewMidY = contentViewSize.height / 2.0
    labelHeight = @finishedHeight / 2.0

    textLabel.frame = [[0, contentViewMidY - (labelHeight * fraction)], [contentViewSize.width, labelHeight + 1]]
    detailTextLabel.frame = [[0, contentViewMidY - (labelHeight * (1 - fraction))], [contentViewSize.width, labelHeight]]
  end
end

class PullDownTableViewCell < TransformableTableViewCell
  def initWithStyle(style, reuseIdentifier: reuseIdentifier)
    if super
      transform = CATransform3DIdentity
      transform.m34 = -1 / 500.to_f
      contentView.layer.setSublayerTransform(transform)
  
      textLabel.layer.anchorPoint = CGPointMake(0.5, 1.0)
      textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight
  
      self.selectionStyle = UITableViewCellSelectionStyleNone
  
      @tintColor = UIColor.whiteColor
    end
    self
  end

  def layoutSubviews
    super

    fraction = self.frame.size.height / @finishedHeight.to_f
    fraction = [[1, fraction].min, 0].max

    angle = (Math::PI / 2) - Math.asin(fraction)
    transform = CATransform3DMakeRotation(angle, 1, 0, 0)
    textLabel.layer.setTransform(transform)

    textLabel.backgroundColor = @tintColor.colorWithBrightness(0.3 + 0.7*fraction)

    contentViewSize = self.contentView.frame.size
    labelHeight = @finishedHeight

    self.textLabel.frame = [[0, contentViewSize.height - labelHeight], [contentViewSize.width, labelHeight]]
  end
end
