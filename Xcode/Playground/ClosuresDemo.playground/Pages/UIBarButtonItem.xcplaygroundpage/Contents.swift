import UIKit;import PlaygroundSupport;PlaygroundPage.current.liveView = navController
import Closures
//: [Go back](@previous)
/*:
 # UIBarButtonItem
 
 `Closures` framework adds closures for `UIBarButtonItem` tap events, usually
 found in a UINavigationBar.
 
 All initializers that support the target-action pattern now have an equivalent
 initialier that contains a `handler` parameter.
 */
navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left item", style: .plain) {
    log("left item tapped")
}
/*:
 To add the closure handler to an existing `UIBarButtonItem`, simply call the
 `onTap(handler:)` method. For instance, if you created your button
 in a storyboard, you could call the following in your `viewDidLoad` method.
 */
let myRightBarButton = navigationItem.rightBarButtonItem!
myRightBarButton.onTap {
    log("right item tapped")
}
