module ValueTransformer
  Celsius = Transformer.withName('Celsius', class:NSNumber) do
    transform { |value| value.to_f - 273.15 }
    reverse   { |value| value.to_f + 273.15 }
  end

  Fahrenheit = Transformer.withName('Fahrenheit', class:NSNumber) do
    transform do |value|
      celsius_2_kelvin_transformer = NSValueTransformer.valueTransformerForName('Celsius')
      celsius_value = celsius_2_kelvin_transformer.transformedValue(value.to_f)
      fahrenheit_value = (1.8 * celsius_value) + 32
    end
    reverse do |fahrenheit_value|
      celsius_2_kelvin_transformer = NSValueTransformer.valueTransformerForName('Celsius')        
      celsius_value = (fahrenheit_value.to_f - 32.0) / 1.8
      celsius_2_kelvin_transformer.reverseTransformedValue(celsius_value)
    end
  end

  Rankine = Transformer.withName('Rankine', class:NSNumber) do
    transform { |kelvin_value| kelvin_value.to_f * 1.8 }
    reverse   { |rankine_value| rankine_value.to_f / 1.8 }
  end

  Delisle = Transformer.withName('Delisle', class: NSNumber) do
    transform do |value|
      c2k_transformer = NSValueTransformer.valueTransformerForName('Celsius')
      celsius_value = c2k_transformer.transformedValue(value.to_f)
      delisle_value = (100 - celsius_value) * 3/2
    end
    reverse do |delisle_value|
      c2k_transformer = NSValueTransformer.valueTransformerForName('Celsius')        
      celsius_value = 100 - (delisle_value.to_f * 2/3)
      c2k_transformer.reverseTransformedValue(celsius_value)
    end
  end

  Newton = Transformer.withName('Newton', class: NSNumber) do
    transform do |value|
      c2k_transformer = NSValueTransformer.valueTransformerForName('Celsius')
      celsius_value = c2k_transformer.transformedValue(value.to_f)
      newton_value  = celsius_value * 33/100
    end
    reverse do |newton_value|
      c2k_transformer = NSValueTransformer.valueTransformerForName('Celsius')        
      celsius_value = newton_value.to_f * 100/33
      c2k_transformer.reverseTransformedValue(celsius_value)
    end
  end

  Reaumur = Transformer.withName('Reaumur', class: NSNumber) do
    transform do |value|
      c2k_transformer = NSValueTransformer.valueTransformerForName('Celsius')
      celsius_value = c2k_transformer.transformedValue(value.to_f)
      reaumur_value = celsius_value * 4/5
    end
    reverse do |reaumur_value|
      c2k_transformer = NSValueTransformer.valueTransformerForName('Celsius')        
      celsius_value = reaumur_value.to_f * 5/4
      c2k_transformer.reverseTransformedValue(celsius_value)
    end
  end

  Romer = Transformer.withName('Romer', class: NSNumber) do
    transform do |value|
      c2k_transformer = NSValueTransformer.valueTransformerForName('Celsius')
      celsius_value = c2k_transformer.transformedValue(value.to_f)
      romer_value = (celsius_value * 21/40) + 7.5
    end
    reverse do |romer_value|
      c2k_transformer = NSValueTransformer.valueTransformerForName('Celsius')        
      celsius_value  = (romer_value.to_f - 7.5) * 40/21
      c2k_transformer.reverseTransformedValue(celsius_value)
    end
  end
end
