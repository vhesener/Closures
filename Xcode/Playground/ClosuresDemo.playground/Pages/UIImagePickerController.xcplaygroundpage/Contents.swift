import UIKit
import Closures
//: [Go back](@previous)
/*:
 # UIImagePickerController
 
 * Callout(Meh):
 UIImagePickerController doesn't exactly work in playgrounds yet
 so this is just example code for now.
 
 The following is an example of using closures to
 select media from a `UIImagePickerController`.
 A simple picker is created which defaults to allowing
 images to be selected from the photos library. This
 initializer will call the handler when an image is selected.
 When preseting with the `present(from:)` method,
 the `UIImagePickerController` will dismiss itself on user cancel
 or after the picker has picked its content (after the closure
 is called).
 
 ```swift
 UIImagePickerController() { result,picker in
     myImageView.image = result.editedImage
 }.present(from: self)
 ```
 
 You can also customize the picker if you need more control, including
 setting your own initial values and delegate callbacks.
 The following is a verbose example using most of the possible
 customization points.
 
 ```swift
 UIImagePickerController(
     source: .camera,
     allow: [.image, .movie],
     cameraOverlay: nil,
     showsCameraControls: true) { result,picker in
         myImageView.image = result.originalImage
 }.didCancel { [weak self] in
     // some custom didCancel implementation
     self?.dismiss(animated: animation.animate)
 }.present(from: self)
 ```
 */

//: * * * *
//: [Click here to explore using **UIBarButtonItem** closures](@next)
//: * * * *
