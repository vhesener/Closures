import UIKit
import PlaygroundSupport

public class CollectionViewDemoViewController: BaseViewController {
    @IBOutlet public var collectionView: UICollectionView!
    @IBOutlet public var segmentedControl: UISegmentedControl!
}

public class MyCustomCollectionViewCell: UICollectionViewCell {
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public let textLabel = UILabel()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel.font = .systemFont(ofSize: 8)
        let labelContainer = contentView
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        labelContainer.addSubview(textLabel)
        textLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: labelContainer.centerYAnchor).isActive = true
    }
}

public let viewController = CollectionViewDemoViewController(nibName: "CollectionViewDemoViewController", bundle: nil)
public let view = viewController.view!
