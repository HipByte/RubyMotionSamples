shared 'Scene' do

  def have_child_named?(name)
    lambda { |obj| !obj.childNodeWithName(name).nil? }
  end

end
