import Foundation
import Closures
//: [Go back](@previous)
/*:
 # Key-Value Observing
 
 The Foundation team at Apple has made great
 strides to become more closuresque, and Swift
 4 has truly proved that with KVO updates.
 
 The API is almost perfect so there isn't too
 much to add. There is only one convenience
 method to improve some of the boiler plate
 code for a typical use case.
 
 The existing API requires you to save the observer
 and store it for the duration of the observation.
 Not bad, but with a little polish we can set and
 forget. Although it looks like more effort to
 provide a conditional remove handler, with the
 helper var `selfDeinits` on every NSObject,
 we don't have to hold onto distracting observer
 variables in our view controllers.
 
 In this example we'll observe the `text`
 property of a UITextField.
 */
let textField = UITextField()
class MyClass: NSObject {
    override init() { super.init()
        textField.observe(\.text, until: selfDeinits) { obj,change in
            print("Observed the change to \"\(obj.text!)\"")
        }
    }
}

var myObject: MyClass? = MyClass()
textField.text = "🐒" // this will be observed
myObject = nil
textField.text = "This will NOT be observed"

//: * * * *
//: [Click here to explore using **UIImagePickerController** closures](@next)
//: * * * *
