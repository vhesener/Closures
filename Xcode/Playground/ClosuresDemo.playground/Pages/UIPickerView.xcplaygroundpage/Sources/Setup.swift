import UIKit
import PlaygroundSupport

public class PickerDemoViewController: BaseViewController, PrintableController {
    @IBOutlet public var segmentedControl: UISegmentedControl!
    @IBOutlet public var pickerView: UIPickerView!
    @IBOutlet public var printableTextView: UITextView?
}

public let viewController = PickerDemoViewController(nibName: "PickerDemoViewController", bundle: nil)
public let view = viewController.view!

public func log(_ string: String) {
    viewController.print(text: string)
    print(string)
}

public func getCountryDayComponents() -> [[String]] {
    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let countries = getAllCountries()
    return [countries, days]
}
