import UIKit
import PlaygroundSupport

public class GesturesDemoViewController: BaseViewController, PrintableController {
    @IBOutlet public var printableTextView: UITextView?
}

public let viewController = GesturesDemoViewController(nibName: "GesturesDemoViewController", bundle: nil)
public let view = viewController.view!

public func log(_ string: String) {
    viewController.print(text: string)
    print(string)
}

public class MyCustomGestureRecognizer: UIGestureRecognizer {}
