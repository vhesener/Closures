/**
 The MIT License (MIT)
 Copyright (c) 2017 Vincent Hesener
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 associated documentation files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
 is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or
 substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import MobileCoreServices
import PhotosUI

fileprivate final class ImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DelegateProtocol {
    static var delegates = Set<DelegateWrapper<UIImagePickerController, ImagePickerControllerDelegate>>()
    
    fileprivate var didFinishPickingMedia: ((_ withInfo: [String: Any]) -> Void)?
    fileprivate func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [String: Any]) {
        didFinishPickingMedia?(info)
    }
    
    fileprivate var didCancel: (() -> Void)?
    fileprivate func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didCancel?()
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(ImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)):
            return didFinishPickingMedia != nil
        case #selector(ImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)):
            return didCancel != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

extension UIImagePickerController {
    // MARK: Convenient Presenting
    /**
     This is a convenience initializer that allows you to setup your
     UIImagePickerController with some commonly used default settings.
     In addition, it provides a default handler for a cancelled picker,
     but you are free to provide your own `didCancel` implementation
     using the `didCancel` parameter. The only required parameter is
     the `didPick` closure, which will be called when the user picks
     a medium.
     
     * important: The picker will not be attempted to be dismissed
     after this closure is called, unless you use the
     `present(from:animation:)` method.
     
     * * * *
     #### An example of initializing with this method:
     ```swift
     let picker = UIImagePickerController(
         source: .camera,
         allow: [.image, .movie]) { [weak self] result,picker in
             myImageView.image = result.originalImage
             self?.dismiss(animated: animation.animate)
         }
     }
     ```
     
     * parameter source: The `UIImagePickerControllerSourceType` that
     UIImagePickerController expects to determine where the content
     should be obtained from. This value will be applied to the
     picker's `sourceType` property.
     * parameter allow: A convenience `OptionSet` filter based on `kUTType` Strings.
     These types will be applied to the picker's mediaTypes property.
     * parameter cameraOverlay: This is equivalent to `UIImagePickerController`'s
     `cameraOverlayView` property and will be applied as such.
     * parameter showsCameraControls: This is equivalent to `UIImagePickerController`'s
     `showsCameraControls` property and will be applied as such.
     * parameter didCancel: The closure that is called when the `didCancel` delegate
     method is called. The default is to attempt to dismiss the picker.
     * parameter didPick: The closure that is called when the
     imagePickerController(_:didFinishPickingMediaWithInfo:) is called.
     The closure conveniently wraps the Dictionary obtained from this
     delegate call in a `Result` struct. The original Dictionary can
     be found in the `rawInfo` property.
     */
    public convenience init(source: UIImagePickerControllerSourceType = .photoLibrary,
                            allow: UIImagePickerController.MediaFilter = .image,
                            cameraOverlay: UIView? = nil,
                            showsCameraControls: Bool = true,
                            didCancel: @escaping ( _ picker: UIImagePickerController) -> Void = dismissFromPresenting,
                            didPick: @escaping (_ result: UIImagePickerController.Result, _ picker: UIImagePickerController) -> Void) {
        self.init()
        sourceType = source
        /**
         From UIImagePickerController docs: "You can access this property
         only when the source type of the image picker is set to camera.
         Attempting to access this property for other source types results in
         throwing an invalidArgumentException exception"
         */
        if source == .camera {
            cameraOverlayView = cameraOverlay
            self.showsCameraControls = showsCameraControls
        }
        mediaTypes = UIImagePickerController.MediaFilter.allTypes.flatMap {
            allow.contains($0) ? $0.mediaType : nil
        }
        didFinishPickingMedia { [unowned self] in
            didPick(UIImagePickerController.Result(rawInfo: $0), self)
        }
    }
    
    public static func dismissFromPresenting(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true)
    }
    
    /**
     A convenience method that will present the UIImagePickerController. It will
     also do the following as default behavior, which can be overriden at anytime:
     
     1. Default the didCancel callback to dismiss the picker.
     1. Call the didFinishPickingMedia handler if one was set previously, usually
     from the convenience initiaizer's `didPick` parameter or by calling
     the `didFinishPickingMedia(_:)` method.
     1. Dismiss the picker after calling the `didFinishPickingMedia` handler.
     
     * * * *
     #### An example of calling this method using the convenience initializer:
     ```swift
     let picker = UIImagePickerController(
         source: .photoLibrary,
         allow: .image) { result,_ in
             myImageView.image = result.originalImage
     }.present(from: self)
     ```
     
     * parameter viewController: The view controller that is able to present the
     picker. This view controller is also used to dismiss the picker for the default
     dismissing behavior.
     * parameter animation: An animation info tuple that describes whether to
     animate the presenting and what to do after the animation is complete.
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func present(from viewController: UIViewController, animation: (animate: Bool, onComplete: (() -> Void)?) = (true, nil)) -> Self {
        didCancel { [weak viewController] in
            viewController?.dismiss(animated: animation.animate)
        }
        update { [weak viewController] delegate in
            let finishedPickingCopy = delegate.didFinishPickingMedia
            delegate.didFinishPickingMedia = {
                finishedPickingCopy?($0)
                viewController?.dismiss(animated: animation.animate)
            }
        }
        viewController.present(self, animated: animation.animate, completion: animation.onComplete)
        return self
    }
}

extension UIImagePickerController {
    // MARK: Delegate Overrides
    /**
     Equivalent to implementing UIImagePickerControllerDelegate's imagePickerController(_:didFinishPickingMediaWithInfo:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didFinishPickingMedia(handler: @escaping (_ withInfo: [String: Any]) -> Void) -> Self {
        return update { $0.didFinishPickingMedia = handler }
    }
    
    /**
     Equivalent to implementing UIImagePickerControllerDelegate's imagePickerControllerDidCancel(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didCancel(handler: @escaping () -> Void) -> Self {
        return update { $0.didCancel = handler }
    }
}

extension UIImagePickerController {
    // MARK: Helper Types
    /**
     A wrapper around `kUTType`. Eventually these will
     be replaced by Apple with a Swifty enum, but until
     then, this simply wraps these values in a strongly
     typed `OptionSet`. You can use these when deciding
     which media types you want the user to select from
     the `UIImagePickerController` using the
     `init(source:allow:cameraOverlay:showsCameraControls:didPick:)`
     initializer.
     
     Since it is an `OptionSet`, you can use array literal
     syntax to describe more than one media type.
     
     ```swift
     let picker = UIImagePickerController(allow: [.image, .movie]) {_,_ in
         // ...
     }
     ```
     */
    public struct MediaFilter: OptionSet {
        /// :nodoc:
        public let rawValue: Int
        /// :nodoc:
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /**
         Tells the UIImagePickerController to allow images
         to be seleced.
         */
        public static let image: MediaFilter = 1
        /**
         Tells the UIImagePickerController to allow movies
         to be seleced.
         */
        public static let movie: MediaFilter = 2
        /**
         Tells the UIImagePickerController to allow all
         explicitly supported `MediaFilter` types to be seleced.
         */
        public static let all: MediaFilter = [.image, .movie]
        
        fileprivate static let allTypes: [MediaFilter] = [.image, .movie]
        
        fileprivate var mediaType: String {
            switch self {
            case .image:
                return kUTTypeImage as String
            case .movie:
                return kUTTypeMovie as String
            default:
                return kUTTypeImage as String
            }
        }
    }
    
    /**
     This result object is a only a wrapper around the loosely
     typed Dictionary returned from `UIImagePickerController`'s
     `-imagePickerController:didFinishPickingMediaWithInfo:` delegate
     method. When using the
     `init(source:allow:cameraOverlay:showsCameraControls:didPick:)`
     initializer, the `didPick` closure passes this convenience struct.
     If the original Dictionary is needed, it can be found in the
     `rawInfo` property.
     */
    public struct Result {
        /**
         The original Dictionary received from UIPickerController's
         `-imagePickerController:didFinishPickingMediaWithInfo:` delegate
         method.
         */
        public let rawInfo: [String: Any]
        /**
         The type of media picked by the user, converted to a
         MediaFilter option. This is equivalent to the
         `UIImagePickerControllerOriginalImage` key value from `rawInfo`.
         */
        public let type: MediaFilter
        /**
         The original UIImage that the user selected from their
         source. This is equivalent to the `UIImagePickerControllerOriginalImage`
         key value from `rawInfo`.
         */
        public let originalImage: UIImage?
        /**
         The edited image after any croping, resizing, etc has occurred.
         This is equivalent to the `UIImagePickerControllerEditedImage`
         key value from `rawInfo`.
         */
        public let editedImage: UIImage?
        /**
         This is equivalent to the `UIImagePickerControllerCropRect` key
         value from `rawInfo`.
         */
        public let cropRect: CGRect?
        /**
         The fileUrl of the movie that was picked. This is equivalent to
         the `UIImagePickerControllerMediaURL` key value from `rawInfo`.
         */
        public let movieUrl: URL?
        /**
         This is equivalent to the `UIImagePickerControllerMediaMetadata` key value from `rawInfo`.
         */
        public let metaData: NSDictionary?
        
        init(rawInfo: [String: Any]) {
            self.rawInfo = rawInfo
            type = (rawInfo[UIImagePickerControllerMediaType] as! CFString).mediaFilter
            originalImage = rawInfo[UIImagePickerControllerOriginalImage] as? UIImage
            editedImage = rawInfo[UIImagePickerControllerEditedImage] as? UIImage
            cropRect = rawInfo[UIImagePickerControllerCropRect] as? CGRect
            movieUrl = rawInfo[UIImagePickerControllerMediaURL] as? URL
            metaData = rawInfo[UIImagePickerControllerMediaMetadata] as? NSDictionary
        }
    }
}

extension UIImagePickerController.MediaFilter: ExpressibleByIntegerLiteral {
    /// :nodoc:
    public init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }
}

fileprivate extension CFString {
    fileprivate var mediaFilter: UIImagePickerController.MediaFilter {
        switch self {
        case kUTTypeImage:
            return .image
        case kUTTypeMovie:
            return .movie
        default:
            return .image
        }
    }
}

extension UIImagePickerController: DelegatorProtocol {
    @discardableResult
    fileprivate func update(handler: (_ delegate: ImagePickerControllerDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: ImagePickerControllerDelegate(),
                               delegates: &ImagePickerControllerDelegate.delegates,
                               bind: UIImagePickerController.bind) {
                                handler($0.delegate)
        }
        return self
    }
    
    // MARK: Reset
    /**
     Clears any delegate closures that were assigned to this
     `UIImagePickerController`. This cleans up memory as well as sets the
     `delegate` property to nil. This is typically only used for explicit
     cleanup. You are not required to call this method.
     */
    @objc public func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &ImagePickerControllerDelegate.delegates)
        UIImagePickerController.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: UIImagePickerController, _ delegate: ImagePickerControllerDelegate?) {
        delegator.delegate = nil
        delegator.delegate = delegate
    }
}
