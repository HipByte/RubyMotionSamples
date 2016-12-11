class ComplicationController
  # Timeline Configuration

  def getSupportedTimeTravelDirectionsForComplication(complication, withHandler:handler)
    handler.call(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward)
  end

  def getTimelineStartDateForComplication(complication, withHandler:handler)
    handler.call(nil)
  end

  def getTimelineEndDateForComplication(complication, withHandler:handler)
    handler.call(nil)
  end

  def getPrivacyBehaviorForComplication(complication, withHandler:handler)
    handler.call(CLKComplicationPrivacyBehaviorShowOnLockScreen)
  end

  # Timeline Population

  def getCurrentTimelineEntryForComplication(complication, withHandler:handler)
    # Call the handler with the current timeline entry
    entry = nil

    case complication.family
    when CLKComplicationFamilyCircularSmall
      image = UIImage.imageNamed("Complication/Circular")
      template = CLKComplicationTemplateCircularSmallSimpleImage.new
      template.imageProvider = CLKImageProvider.imageProviderWithOnePieceImage(image)
      entry = CLKComplicationTimelineEntry.entryWithDate(Time.now, complicationTemplate:template)

    when CLKComplicationFamilyUtilitarianSmall
      image = UIImage.imageNamed("Complication/Circular")
      template = CLKComplicationTemplateUtilitarianSmallRingImage.new
      template.imageProvider = CLKImageProvider.imageProviderWithOnePieceImage(image)
      template.ringStyle = CLKComplicationRingStyleClosed
      entry = CLKComplicationTimelineEntry.entryWithDate(Time.now, complicationTemplate:template)

    when CLKComplicationFamilyUtilitarianLarge
      image = UIImage.imageNamed("Complication/Circular")
      template = CLKComplicationTemplateUtilitarianLargeFlat.new
      template.textProvider = CLKSimpleTextProvider.textProviderWithText("RubyMotion sample")
      template.imageProvider = CLKImageProvider.imageProviderWithOnePieceImage(image)
      entry = CLKComplicationTimelineEntry.entryWithDate(Time.now, complicationTemplate:template)

    when CLKComplicationFamilyModularLarge
      template = CLKComplicationTemplateModularLargeStandardBody.new
      template.headerTextProvider = CLKSimpleTextProvider.textProviderWithText("RubyMotion sample")
      template.body1TextProvider = CLKSimpleTextProvider.textProviderWithText("This is Complication sample")
      entry = CLKComplicationTimelineEntry.entryWithDate(Time.now, complicationTemplate:template)

    end

    handler.call(entry)
  end

  def getTimelineEntriesForComplication(complication, beforeDate:date, limit:limit, withHandler:handler)
    # Call the handler with the timeline entries prior to the given date
    handler.call(nil)
  end

  def getTimelineEntriesForComplication(complication, afterDate:date, limit:limit, withHandler:handler)
    # Call the handler with the timeline entries after to the given date
    handler.call(nil)
  end

  # Placeholder Templates

  def getLocalizableSampleTemplateForComplication(complication, withHandler:handler)
    # This method will be called once per supported complication, and the results will be cached
    handler.call(nil)
  end

end
