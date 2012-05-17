class CustomViewController2 < UIViewController
  TAG_IDLABEL     = 1
  TAG_DESCRIPTION = 2
  TAG_CUSTOMTEXT  = 3

  def viewDidLoad
    puts "#{self.to_s}: CustomViewController2::viewDidLoad"
    self.title = "CustomVC2"

    @idlabel ||= retrieveSubviewWithTag(self, TAG_IDLABEL)
    @idlabel.text = self.to_s
    
    @description ||= retrieveSubviewWithTag(self, TAG_DESCRIPTION)
    @customtext ||= retrieveSubviewWithTag(self, TAG_CUSTOMTEXT)
  end

  def setParentId(id)
    @description ||= retrieveSubviewWithTag(self, TAG_DESCRIPTION)
    @description.text = "Custom text from #{id}:"
  end

  def customtext
    @customtext ||= retrieveSubviewWithTag(self, TAG_CUSTOMTEXT)
    @customtext
  end
end