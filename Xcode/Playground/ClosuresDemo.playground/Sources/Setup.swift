import UIKit
import PlaygroundSupport

public protocol PrintableController {
    var printableTextView: UITextView? {get}
    func print(text: String)
}

extension PrintableController {
    public func print(text: String) {
        guard let textView = printableTextView else {
            return
        }
        textView.text = textView.text + "\n" + text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let location = textView.text?.count,
                location > 0 else {
                    return
            }
            textView.scrollRangeToVisible(NSMakeRange(location, 1))
        }
    }
}

open class BaseViewController: UIViewController {}

public func getAllCountries() -> [String] {
    let locale = Locale(identifier:"en_US")
    return Locale.isoRegionCodes.flatMap {
        locale.localizedString(forRegionCode: $0)!
        }.sorted()
}

public extension Array where Element == String {
    var sectionedByFirstLetter: [[String]] {
        let sections = Dictionary(grouping: self) { $0.first! }
        return sections.keys.sorted().map {
            sections[$0]!
        }
    }
}
