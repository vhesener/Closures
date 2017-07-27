import UIKit
import PlaygroundSupport

public class TableViewDemoViewController: BaseViewController {
    @IBOutlet public var tableView: UITableView!
    @IBOutlet public var segmentedControl: UISegmentedControl!
}

public let viewController = TableViewDemoViewController(nibName: "TableViewDemoViewController", bundle: nil)
public let view = viewController.view!
