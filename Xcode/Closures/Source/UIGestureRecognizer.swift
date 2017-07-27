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

fileprivate extension UIGestureRecognizer {
    @objc func gestureRecognized() {
        NotificationCenter.closures.post(name: .gestureRecognized, object: self)
    }
}

fileprivate extension Notification.Name {
    static let gestureRecognized = Notification.Name("UIGestureRecognizer.recognized")
}

/**
 This method is a convenience method to add a closure handler to a custom subclass of
 UIGestureRecognizer. If creating a custom gesture recognizer, you may want to also
 provide an initializer that takes a completion handler, just as the Closures
 framework provides for UIKit gesture recognizers.
 
 * * * *
 #### An example of an initializer that adds closure support for recognition of custom gesture recognizer:
 
 ```swift
 class MyCustomGestureRecognizer: UIGestureRecognizer {
     convenience init(handler: @escaping (_ gesture: MyCustomGestureRecognizer) -> Void) {
         self.init()
         configure(target: self, handler: handler)
     }
 }
 ```
 
 * parameter gesture: The UIGestureRecognizer that is being configured to use a closure in place of target-action.
 * parameter handler: The closure that will be called when the gesture is recognized.
 */
public func configure<T>(gesture: T, handler: @escaping (_ gesture: T) -> Void)
    where T: UIGestureRecognizer {
        gesture.addTarget(gesture, action: #selector(UIGestureRecognizer.gestureRecognized))
        NotificationCenter.selfObserve(name: .gestureRecognized, target: gesture) { gesture,userInfo in
            handler(gesture)
        }
}

extension UITapGestureRecognizer {
    /**
     A convenience initializer for a UITapGestureRecognizer so that it
     can be configured with a single line of code.
     
     * parameter tapsRequired: Defaults UITapGestureRecognizer's `numberOfTapsRequired` property value
     * parameter touchesRequired: Defaults UITapGestureRecognizer's `numberOfTouchesRequired` property value
     * parameter handler: The closure that is called when the gesture is recognized
     */
    public convenience init(tapsRequired: Int = 1,
                            touchesRequired: Int = 1,
                            handler: @escaping (_ gesture: UITapGestureRecognizer) -> Void) {
        self.init()
        configure(gesture: self, handler: handler)
        numberOfTapsRequired = tapsRequired
        numberOfTouchesRequired = touchesRequired
    }
}

extension UIView {
    // MARK: Add Gesture Convenience
    /**
     A convenience method that adds a UITapGestureRecognizer to a view, while also
     passing default values to its convenience initializer.
     
     * parameter tapsRequired: Defaults UITapGestureRecognizer's `numberOfTapsRequired` property value
     * parameter touchesRequired: Defaults UITapGestureRecognizer's `numberOfTouchesRequired` property value
     * parameter handler: The closure that is called when the gesture is recognized
     
     * returns: The gesture that was created so that it can be used to daisy chain other
     customizations
     */
    @discardableResult
    public func addTapGesture(tapsRequired: Int = 1,
                              touchesRequired: Int = 1,
                              handler: @escaping (_ gesture: UITapGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(tapsRequired: tapsRequired,
                                             touchesRequired: touchesRequired,
                                             handler: handler)
        addGestureRecognizer(gesture)
        return gesture
    }
}

extension UILongPressGestureRecognizer {
    /**
     A convenience initializer for a UILongPressGestureRecognizer so that it
     can be configured with a single line of code.
     
     * parameter tapsRequired: Defaults UILongPressGestureRecognizer's `numberOfTapsRequired` property value
     * parameter touchesRequired: Defaults UILongPressGestureRecognizer's `numberOfTouchesRequired` property value
     * parameter minDuration: Defaults UILongPressGestureRecognizer's `minimumPressDuration` property value
     * parameter allowableMovement: Defaults UILongPressGestureRecognizer's `allowableMovement` property value
     * parameter handler: The closure that is called when the gesture is recognized
     */
    public convenience init(tapsRequired: Int = 0,
                            touchesRequired: Int = 1,
                            minDuration: CFTimeInterval = 0.5,
                            allowableMovement: CGFloat = 10,
                            handler: @escaping (_ gesture: UILongPressGestureRecognizer) -> Void) {
        self.init()
        configure(gesture: self, handler: handler)
        numberOfTapsRequired = tapsRequired
        numberOfTouchesRequired = touchesRequired
        minimumPressDuration = minDuration
        self.allowableMovement = allowableMovement
    }
}

extension UIView {
    /**
     A convenience method that adds a UILongPressGestureRecognizer to a view, while also
     passing default values to its convenience initializer.
     
     * parameter tapsRequired: Defaults UILongPressGestureRecognizer's `numberOfTapsRequired` property value
     * parameter touchesRequired: Defaults UILongPressGestureRecognizer's `numberOfTouchesRequired` property value
     * parameter minDuration: Defaults UILongPressGestureRecognizer's `minimumPressDuration` property value
     * parameter allowableMovement: Defaults UILongPressGestureRecognizer's `allowableMovement` property value
     * parameter handler: The closure that is called when the gesture is recognized
     
     * returns: The gesture that was created so that it can be used to daisy chain other
     customizations
     */
    @discardableResult
    public func addLongPressGesture(tapsRequired: Int = 0,
                                    touchesRequired: Int = 1,
                                    minDuration: CFTimeInterval = 0.5,
                                    allowableMovement: CGFloat = 10,
                                    handler: @escaping (_ gesture: UILongPressGestureRecognizer) -> Void) -> UILongPressGestureRecognizer {
        let gesture = UILongPressGestureRecognizer(tapsRequired: tapsRequired,
                                                   touchesRequired: touchesRequired,
                                                   minDuration: minDuration,
                                                   allowableMovement: allowableMovement,
                                                   handler: handler)
        addGestureRecognizer(gesture)
        return gesture
    }
}

extension UIPinchGestureRecognizer {
    /**
     A convenience initializer for a UIPinchGestureRecognizer so that it
     can be configured with a single line of code.
     
     * parameter handler: The closure that is called when the gesture is recognized
     */
    public convenience init(handler: @escaping (_ gesture: UIPinchGestureRecognizer) -> Void) {
        self.init()
        configure(gesture: self, handler: handler)
    }
}

extension UIView {
    /**
     A convenience method that adds a UIPinchGestureRecognizer to a view, while also
     passing default values to its convenience initializer.
     
     * parameter handler: The closure that is called when the gesture is recognized
     
     * returns: The gesture that was created so that it can be used to daisy chain other
     customizations
     */
    @discardableResult
    public func addPinchGesture(handler: @escaping (_ gesture: UIPinchGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        let gesture = UIPinchGestureRecognizer(handler: handler)
        addGestureRecognizer(gesture)
        return gesture
    }
}

extension UISwipeGestureRecognizer {
    /**
     A convenience initializer for a UISwipeGestureRecognizer so that it
     can be configured with a single line of code.
     
     * parameter direction: Defaults UISwipeGestureRecognizer's `direction` property value
     * parameter touchesRequired: Defaults UISwipeGestureRecognizer's `numberOfTouchesRequired` property value
     * parameter handler: The closure that is called when the gesture is recognized
     */
    public convenience init(direction: UISwipeGestureRecognizerDirection = .right,
                            touchesRequired: Int = 1,
                            handler: @escaping (_ gesture: UISwipeGestureRecognizer) -> Void) {
        self.init()
        configure(gesture: self, handler: handler)
        self.direction = direction
        self.numberOfTouchesRequired = touchesRequired
    }
}

extension UIView {
    /**
     A convenience method that adds a UISwipeGestureRecognizer to a view, while also
     passing default values to its convenience initializer.
     
     * parameter direction: Defaults UISwipeGestureRecognizer's `direction` property value
     * parameter touchesRequired: Defaults UISwipeGestureRecognizer's `numberOfTouchesRequired` property value
     * parameter handler: The closure that is called when the gesture is recognized
     
     * returns: The gesture that was created so that it can be used to daisy chain other
     customizations
     */
    @discardableResult
    public func addSwipeGesture(direction: UISwipeGestureRecognizerDirection = .right,
                                touchesRequired: Int = 1,
                                handler: @escaping (_ gesture: UISwipeGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {
        let gesture = UISwipeGestureRecognizer(direction: direction,
                                               touchesRequired: touchesRequired,
                                               handler: handler)
        addGestureRecognizer(gesture)
        return gesture
    }
}

extension UIRotationGestureRecognizer {
    /**
     A convenience initializer for a UIRotationGestureRecognizer so that it
     can be configured with a single line of code.
     
     * parameter handler: The closure that is called when the gesture is recognized
     */
    public convenience init(handler: @escaping (_ gesture: UIRotationGestureRecognizer) -> Void) {
        self.init()
        configure(gesture: self, handler: handler)
    }
}

extension UIView {
    /**
     A convenience method that adds a UIRotationGestureRecognizer to a view, while also
     passing default values to its convenience initializer.
     
     * parameter handler: The closure that is called when the gesture is recognized
     
     * returns: The gesture that was created so that it can be used to daisy chain other
     customizations
     */
    @discardableResult
    public func addRotationGesture(handler: @escaping (_ gesture: UIRotationGestureRecognizer) -> Void) -> UIRotationGestureRecognizer {
        let gesture = UIRotationGestureRecognizer(handler: handler)
        addGestureRecognizer(gesture)
        return gesture
    }
}

extension UIPanGestureRecognizer {
    /**
     A convenience initializer for a UIPanGestureRecognizer so that it
     can be configured with a single line of code.
     
     * parameter minTouches: Defaults UIPanGestureRecognizer's `minimumNumberOfTouches` property value
     * parameter maxTouches: Defaults UIPanGestureRecognizer's `maximumNumberOfTouches` property value
     * parameter handler: The closure that is called when the gesture is recognized
     */
    public convenience init(minTouches: Int = 1,
                            maxTouches: Int = .max,
                            handler: @escaping (_ gesture: UIPanGestureRecognizer) -> Void) {
        self.init()
        configure(gesture: self, handler: handler)
        minimumNumberOfTouches = minTouches
        maximumNumberOfTouches = maxTouches
    }
}

extension UIView {
    /**
     A convenience method that adds a UIPanGestureRecognizer to a view, while also
     passing default values to its convenience initializer.
     
     * parameter minTouches: Defaults UIPanGestureRecognizer's `minimumNumberOfTouches` property value
     * parameter maxTouches: Defaults UIPanGestureRecognizer's `maximumNumberOfTouches` property value
     * parameter handler: The closure that is called when the gesture is recognized
     
     * returns: The gesture that was created so that it can be used to daisy chain other
     customizations
     */
    @discardableResult
    public func addPanGesture(minTouches: Int = 1,
                              maxTouches: Int = .max,
                              handler: @escaping (_ gesture: UIPanGestureRecognizer) -> Void) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer(minTouches: minTouches,
                                             maxTouches: maxTouches,
                                             handler: handler)
        addGestureRecognizer(gesture)
        return gesture
    }
}

extension UIScreenEdgePanGestureRecognizer {
    /**
     A convenience initializer for a UIScreenEdgePanGestureRecognizer so that it
     can be configured with a single line of code.
     
     * parameter edges: Defaults UIScreenEdgePanGestureRecognizer's `edges` property value
     * parameter handler: The closure that is called when the gesture is recognized
     */
    public convenience init(edges: UIRectEdge = .all,
                            handler: @escaping (_ gesture: UIScreenEdgePanGestureRecognizer) -> Void) {
        self.init()
        configure(gesture: self, handler: handler)
        self.edges = edges
    }
}

extension UIView {
    /**
     A convenience method that adds a UIScreenEdgePanGestureRecognizer to a view, while also
     passing default values to its convenience initializer.
     
     * parameter edges: Defaults UIScreenEdgePanGestureRecognizer's `edges` property value
     * parameter handler: The closure that is called when the gesture is recognized
     
     * returns: The gesture that was created so that it can be used to daisy chain other
     customizations
     */
    @discardableResult
    public func addScreenEdgePanGesture(edges: UIRectEdge = .all,
                                        handler: @escaping (_ gesture: UIScreenEdgePanGestureRecognizer) -> Void) -> UIScreenEdgePanGestureRecognizer {
        let gesture = UIScreenEdgePanGestureRecognizer(edges: edges,
                                                       handler: handler)
        addGestureRecognizer(gesture)
        return gesture
    }
}

fileprivate final class GestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate, DelegateProtocol {
    static var delegates = Set<DelegateWrapper<UIGestureRecognizer, GestureRecognizerDelegate>>()
    
    fileprivate var shouldBegin: (() -> Bool)?
    fileprivate func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldBegin?() ?? true
    }
    
    fileprivate var shouldRecognizeSimultaneouslyWith: ((_ otherGestureRecognizer: UIGestureRecognizer) -> Bool)?
    fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldRecognizeSimultaneouslyWith?(otherGestureRecognizer) ?? false
    }
    
    fileprivate var shouldRequireFailureOf: ((_ otherGestureRecognizer: UIGestureRecognizer) -> Bool)?
    fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldRequireFailureOf?(otherGestureRecognizer) ?? false
    }
    
    fileprivate var shouldBeRequiredToFailBy: ((_ otherGestureRecognizer: UIGestureRecognizer) -> Bool)?
    fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldBeRequiredToFailBy?(otherGestureRecognizer) ?? false
    }
    
    fileprivate var shouldReceiveTouch: ((_ touch: UITouch) -> Bool)?
    fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return shouldReceiveTouch?(touch) ?? true
    }
    
    fileprivate var shouldReceivePress: ((_ press: UIPress) -> Bool)?
    fileprivate func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return shouldReceivePress?(press) ?? true
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(GestureRecognizerDelegate.gestureRecognizerShouldBegin(_:)):
            return shouldBegin != nil
        case #selector(GestureRecognizerDelegate.gestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)):
            return shouldRecognizeSimultaneouslyWith != nil
        case #selector(GestureRecognizerDelegate.gestureRecognizer(_:shouldRequireFailureOf:)):
            return shouldRequireFailureOf != nil
        case #selector(GestureRecognizerDelegate.gestureRecognizer(_:shouldBeRequiredToFailBy:)):
            return shouldBeRequiredToFailBy != nil
        case #selector((GestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:)) as (GestureRecognizerDelegate) -> (UIGestureRecognizer, UITouch) -> (Bool)):
            return shouldReceiveTouch != nil
        case #selector(GestureRecognizerDelegate.gestureRecognizer(_:shouldReceive:) as (GestureRecognizerDelegate) -> (UIGestureRecognizer, UIPress) -> (Bool)):
            return shouldReceivePress != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

extension UIGestureRecognizer {
    // MARK: Delegate Overrides
    /**
     Equivalent to implementing UIGestureRecognizerDelegate's gestureRecognizerShouldBegin(:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldBegin(handler: @escaping () -> Bool) -> Self {
        return update { $0.shouldBegin = handler }
    }
    
    /**
     Equivalent to implementing UIGestureRecognizerDelegate's gestureRecognizer(:shouldRecognizeSimultaneouslyWith:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldRecognizeSimultaneouslyWith(handler: @escaping (_ otherGestureRecognizer: UIGestureRecognizer) -> Bool) -> Self {
        return update { $0.shouldRecognizeSimultaneouslyWith = handler }
    }
    
    /**
     Equivalent to implementing UIGestureRecognizerDelegate's gestureRecognizer(:shouldRequireFailureOf:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldRequireFailureOf(handler: @escaping (_ otherGestureRecognizer: UIGestureRecognizer) -> Bool) -> Self {
        return update { $0.shouldRequireFailureOf = handler }
    }
    
    /**
     Equivalent to implementing UIGestureRecognizerDelegate's gestureRecognizer(:shouldBeRequiredToFailBy:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldBeRequiredToFailBy(handler: @escaping (_ otherGestureRecognizer: UIGestureRecognizer) -> Bool) -> Self {
        return update { $0.shouldBeRequiredToFailBy = handler }
    }
    
    /**
     Equivalent to implementing UIGestureRecognizerDelegate's gestureRecognizer(:shouldReceive:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldReceiveTouch(handler: @escaping (_ touch: UITouch) -> Bool) -> Self {
        return update { $0.shouldReceiveTouch = handler }
    }
    
    /**
     Equivalent to implementing UIGestureRecognizerDelegate's gestureRecognizer(:shouldReceive:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldReceivePress(handler: @escaping (_ press: UIPress) -> Bool) -> Self {
        return update { $0.shouldReceivePress = handler }
    }
}

extension UIGestureRecognizer: DelegatorProtocol {
    @discardableResult
    fileprivate func update(handler: (_ delegate: GestureRecognizerDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: GestureRecognizerDelegate(),
                               delegates: &GestureRecognizerDelegate.delegates,
                               bind: UIGestureRecognizer.bind) {
                                handler($0.delegate)
        }
        return self
    }
    
    // MARK: Reset
    /**
     Clears any delegate closures that were assigned to this
     `UIGestureRecognizer`. This cleans up memory as well as sets the
     delegate property to nil. This is typically only used for explicit
     cleanup. You are not required to call this method.
     */
    @objc public func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &GestureRecognizerDelegate.delegates)
        UIGestureRecognizer.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: UIGestureRecognizer, _ delegate: GestureRecognizerDelegate?) {
        delegator.delegate = nil
        delegator.delegate = delegate
    }
}
