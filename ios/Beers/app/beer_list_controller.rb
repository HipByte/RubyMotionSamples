class BeerListController < UITableViewController
  def init
    if super
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
      cell.selectionStyle = UITableViewCellSelectionStyleNone
      cell
    end

    beer = Beer::All[indexPath.row]
    cell.textLabel.text = beer.title
    cell
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    beer = Beer::All[indexPath.row]
    controller = UIApplication.sharedApplication.delegate.beer_details_controller
    navigationController.pushViewController(controller, animated:true)
    controller.showDetailsForBeer(beer)
  end
end
