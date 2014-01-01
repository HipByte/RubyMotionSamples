class WindowController < NSWindowController

  def initialize(window)
    initWithWindow(window)
    self.window.minSize = window.frame.size
    self.window.maxSize = window.frame.size
    self.window.center
    self.window.setContentBorderThickness(30.0, forEdge:CGRectMinYEdge)
    self.window.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    self.loadWindow
  end

  def loadWindow
    windowWillLoad
    super
    windowDidLoad
  end

  def windowWillLoad
    super
    c2k = NSValueTransformer.valueTransformerForName 'Celsius'
    kelvinWaterBoilingPoint = c2k.reverseTransformedValue(100)
    hash = { last_temperature: kelvinWaterBoilingPoint }

    defaults = NSUserDefaults.standardUserDefaults
    unless defaults.doubleForKey(:last_temperature)
      puts defaults
      defaults.setDouble(kelvinWaterBoilingPoint, forKey: :last_temperature)
    end
    @udc = NSUserDefaultsController.sharedUserDefaultsController
    @udc.appliesImmediately = true
  end

  def windowDidLoad
    super
    self.window.contentView.addSubview(self.form)
    createBindings
  end

  # Create a NSForm with 8 entries, this entries are created with a title
  def form
    @_form ||= NSForm.alloc.initWithFrame([[15, 40], [531, 200]]).tap do |f|
      f.addEntry 'Kelvin:'
      f.addEntry 'Celsius:'
      f.addEntry 'Fahrenheit:'
      f.addEntry 'Rankine:'
      f.addEntry 'Delisle:'
      f.addEntry 'Newton:'
      f.addEntry 'Réaumur:'
      f.addEntry 'Rømer'

      f.cells.each_with_index do |cell, index|
        cell.formatter = self.numberFormatter
        cell.tag = index
        f.setToolTip("Temperatur in #{cell.title[0..-2]}", forCell:cell)
      end
      
      # set cells size
      f.cellSize = NSSize.new(531, 25)
      f.sizeToCells
      f.setTitleFont NSFont.systemFontOfSize(16)
      f.setTextFont NSFont.systemFontOfSize(16)
    end
  end

  def numberFormatter
    @_numberFormatter ||= NSNumberFormatter.alloc.init.tap do |fm|
      fm.locale = NSLocale.autoupdatingCurrentLocale
      fm.formatterBehavior = NSNumberFormatterBehavior10_4
      fm.numberStyle = NSNumberFormatterScientificStyle
      fm.negativeFormat = '-#,##0.00'
      fm.positiveFormat = '#,##0.00'
      fm.usesSignificantDigits = true
      fm.maximumFractionDigits = 3
      fm.roundingMode = NSNumberFormatterRoundFloor
    end
  end

  private

  # programmatically binding NSFormCell to NSUserDefaultsController
  def createBindings
    opts = {
      NSContinuouslyUpdatesValueBindingOption   => true,
      NSAllowsNullArgumentBindingOption         => false,
      NSInsertsNullPlaceholderBindingOption     => true,
      NSRaisesForNotApplicableKeysBindingOption => true
    }
    
    keypath = 'values.last_temperature'
    transformers = %W[Celsius Fahrenheit Rankine Delisle Newton Reaumur Romer]
    self.form.cells.first.bind(NSValueBinding, toObject: @udc, withKeyPath: keypath, options: opts)

    self.form.cells[1..-1].zip(transformers) do |cell, transformer|
      h = { NSValueTransformerNameBindingOption => transformer }
      cell.bind(NSValueBinding, toObject: @udc, withKeyPath: keypath, options:opts.merge(h))
    end
  end  
end