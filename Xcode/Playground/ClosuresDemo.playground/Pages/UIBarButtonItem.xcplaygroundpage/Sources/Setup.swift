import UIKit
import PlaygroundSupport

public class BarButtonDemoViewController: BaseViewController, PrintableController {
    @IBOutlet public var printableTextView: UITextView?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // supposed to simulate a button item created from a xib/storyboard
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right item", style: .plain, target: nil, action: nil)
    }
}

public let viewController = BarButtonDemoViewController(nibName: "BarButtonDemoViewController", bundle: nil)
public let navController = UINavigationController(rootViewController: viewController)
public let navigationItem = viewController.navigationItem

public func log(_ string: String) {
    viewController.print(text: string)
    print(string)
}
