import UIKit
import PlaygroundSupport

public class ControlsDemoViewController: BaseViewController, PrintableController {
    
    @IBOutlet public var button: UIButton!
    @IBOutlet public var textField: UITextField!
    @IBOutlet public var uiSwitch: UISwitch!
    @IBOutlet public var slider: UISlider!
    @IBOutlet public var segmentedControl: UISegmentedControl!
    @IBOutlet public var stepper: UIStepper!
    @IBOutlet public var pageControl: UIPageControl!
    @IBOutlet public var datePicker: UIDatePicker!
    @IBOutlet public var scrollView: UIScrollView!
    @IBOutlet public var stackView: UIStackView!
    @IBOutlet public var printableTextView: UITextView?
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = stackView.bounds.size
    }
    
    @IBAction public func doneTapped() {
        view.endEditing(true)
    }
    
    public func convert(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
}

public let viewController = ControlsDemoViewController(nibName: "ControlsDemoViewController", bundle: nil)
public let view = viewController.view!

public func log(_ string: String) {
    viewController.print(text: string)
    print(string)
}

public func log(_ date: Date) {
    let dateString = viewController.convert(date: date)
    log(dateString)
}

public let button = viewController.button!
public let textfield = viewController.textField!
public let slider = viewController.slider!
public let segmentedControl = viewController.segmentedControl!
public let stepper = viewController.stepper!
public let pageControl = viewController.pageControl!
public let uiSwitch = viewController.uiSwitch!
public let datePicker = viewController.datePicker!
