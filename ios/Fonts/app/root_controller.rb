class RootController < UITableViewController
  def viewDidLoad
    view.dataSource = view.delegate = self
    navigationItem.title = "Fonts"
  end

  def numberOfSectionsInTableView(tableView)
    fonts.count
  end

  def tableView(tableView, titleForHeaderInSection:section)
    fonts[section][:family]
  end

  def sectionIndexTitlesForTableView(tableView)
    fonts.map do |e|
      e[:family].slice(0)
    end.uniq
  end

  def tableView(tableView, sectionForSectionIndexTitle:title, atIndex:index)
    fonts.map do |e|
      e[:family].slice(0)
    end.index(title)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    fonts[section][:fonts].count
  end

  CELLID = "fonts"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      cell.selectionStyle = UITableViewCellSelectionStyleBlue
      cell
    end

    font_dict = fonts[indexPath.section]
    font_name = font_dict[:fonts][indexPath.row]
    cell.textLabel.font = UIFont.fontWithName(font_name, size:18)
    cell.textLabel.text = font_name
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    font_dict = fonts[indexPath.section]
    font_name = font_dict[:fonts][indexPath.row]

    @detail_controller ||= DetailController.alloc.init
    @detail_controller.selected_font(font_name)
    self.navigationController.pushViewController(@detail_controller, animated:true)
  end

  def fonts
    @fonts ||= begin
      UIFont.familyNames.sort.map do |family|
        fonts = UIFont.fontNamesForFamilyName(family).sort
        {:family => family, :fonts => fonts}
      end
    end
  end
end
