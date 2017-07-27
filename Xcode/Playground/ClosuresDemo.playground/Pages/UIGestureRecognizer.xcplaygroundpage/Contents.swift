import UIKit;import PlaygroundSupport;PlaygroundPage.current.liveView = viewController
import Closures
//: [Go back](@previous)
/*:
 # UIGestureRecognizer
 
 The `UIGestureRecognizer` initializers and delegation wrappers
 make it easy to add gesture recognizers to views. It also uses
 closures instead of target-action and delegation.
 
 ## Target-Action Initializers
 
 The following is how you would add a double tap gesture
 recognizer to your view using one of the custom initializers.
 As always, we have a closure handler to respond to the gesture's
 double tap action.
 */
let doubleTapGesture = UITapGestureRecognizer(tapsRequired: 2) { _ in
    log("double tapped")
}
view.addGestureRecognizer(doubleTapGesture)
/*:
 These convenience initializers, delegate closures, and closure recognizers
 have been added to all of the existing concrete subclasses, including:
 
 * `UITapGestureRecognizer`
 * `UIPinchGestureRecognizer`
 * `UIRotationGestureRecognizer`
 * `UISwipeGestureRecognizer`
 * `UIPanGestureRecognizer`
 * `UIScreenEdgePanGestureRecognizer`
 * `UILongPressGestureRecognizer`
 
 There is also a method for you to configure a custom gesture recognizer
 to use closure handlers for recognition:
 */
let myCustomGesture = MyCustomGestureRecognizer()
configure(gesture: myCustomGesture) { _ in
    /// a closure that's called when the gesture has ended
}
/*:
 ## Delegation
 With convenient extension methods on `UIGestureRecognizer` and `UIView`,
 we can daisy chain an entire gesture cycle, including responding
 to `UIGestureRecognizerDelegate` methods.
 */
view
    .addPanGesture() { pan in
        guard pan.state == .ended else { return }
        log("view panned")
    }.shouldBegin() {
        true
    }.shouldRecognizeSimultaneouslyWith {
        $0 === doubleTapGesture
}
//: * * * *
//: [Click here to explore using **UIPickerView** closures](@next)
//: * * * *
