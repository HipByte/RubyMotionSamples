class BeerListController < UITableViewController
  def initWithDetailsController(beer_details_controller)
    @beer_details_controller = beer_details_controller
    if init
      self.tabBarItem = UITabBarItem.alloc.initWithTitle('List', image:UIImage.imageNamed('list.png'), tag:1)
    end
    self
  end

  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:true)
  end    

  def tableView(tableView, numberOfRowsInSection:section)
    Beer::All.size
  end

  CELLID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
      cell
    end

    beer = Beer::All[indexPath.row]
    cell.textLabel.text = beer.title
    return cell
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    beer = Beer::All[indexPath.row]
    navigationController.pushViewController(@beer_details_controller, animated:true)
    @beer_details_controller.showDetailsForBeer(beer)
  end
end
