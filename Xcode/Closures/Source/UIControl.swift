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

fileprivate extension UIControl {
    func _onChange<ControlType, ValueType>(
        callerHandler: @escaping (_ value: ValueType) -> (Void),
        valueHandler: @escaping (_ control: ControlType) -> (ValueType)) {
        on(.valueChanged) { control, _ in
            guard let castedControl = control as? ControlType else {
                return
            }
            callerHandler(valueHandler(castedControl))
        }
    }
}

extension UIControl {
    public typealias EventHandler = (_ sender: UIControl, _ forEvent: UIEvent?) -> Void
    /**
     Provide a handler that will be called for UIControlEvents option passed in.
     
     * * * *
     #### To use this method just call it from a UIControl instance like so:
     ```swift
     myButton.on(.touchUpInside) { control, event in
         <# button tapped code #>
     }
     ```
     
     * warning: You must only pass in one UIControlEvents option to this method. Providing
     something such as `[.touchUpOutside, .touchUpInside]` is currently not
     supported yet.
     
     * parameter events: The UIControlEvents option to listen for
     * parameter handler: The callback closure you wish to be called for this event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func on(_ events: UIControl.Event, handler: @escaping EventHandler) -> Self {
        guard let selector = selectorSignature(for: events) else {
            return self
        }
        removeTarget(self, action: selector, for: events)
        addTarget(self, action: selector, for: events)
        NotificationCenter.selfObserve(
            name: notificationName(for: events),
            target: self) {
                handler($0, $1?[UIControl.eventKey] as? UIEvent)
        }
        return self
    }

    /**
     Methods to react to all the UIControlEvents types. Sadly, these cannot be
     combined into one method because UIKit does not send the UIControlEvents type
     in the target selector anywhere.
     */
    @objc func touchDown(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchDown)
    }
    @objc func touchDownRepeat(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchDownRepeat)
    }
    @objc func touchDragInside(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchDragInside)
    }
    @objc func touchDragOutside(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchDragOutside)
    }
    @objc func touchDragEnter(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchDragEnter)
    }
    @objc func touchDragExit(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchDragExit)
    }
    @objc func touchUpInside(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchUpInside)
    }
    @objc func touchUpOutside(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchUpOutside)
    }
    @objc func touchCancel(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .touchCancel)
    }
    @objc func valueChanged(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .valueChanged)
    }
    @objc func primaryActionTriggered(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .primaryActionTriggered)
    }
    @objc func editingDidBegin(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .editingDidBegin)
    }
    @objc func editingChanged(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .editingChanged)
    }
    @objc func editingDidEnd(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .editingDidEnd)
    }
    @objc func editingDidEndOnExit(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .editingDidEndOnExit)
    }
    @objc func allTouchEvents(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .allTouchEvents)
    }
    @objc func allEditingEvents(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .allEditingEvents)
    }
    @objc func applicationReserved(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .applicationReserved)
    }
    @objc func systemReserved(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .systemReserved)
    }
    @objc func allEvents(sender: UIControl, event: UIEvent?) {
        trigger(sender, event, for: .allEvents)
    }
    
    /// Used to pass the event through the notification userInfo object
    private static let eventKey = String.namespace + ".notificcations.keys.event"
    
    /**
     Provide a handler that will be called for UIControlEvents option passed in.
     
     * parameter sender: The UIControl
     * parameter event: The UIControlEvents option to listen for
     * parameter type: The UIControlEvents option to listen for
     
     */
    private func trigger(_ sender: UIControl, _ event: UIEvent?, for type: UIControl.Event) {
        NotificationCenter.closures.post(name: notificationName(for: type),
                                         object: self,
                                         userInfo: [UIControl.eventKey: event as Any])
    }
    
    /**
     Creates a value for Notification that represents the event type
     
     * parameter events: The UIControleEvents option identifying the
     type of notification
     
     * returns: An identifyable Notification.Name
     */
    private func notificationName(for events: UIControl.Event) -> Notification.Name {
        return Notification.Name("\(String.namespace).notifications.names.UIControlTargetAction.\(events)")
    }
}

extension UIControl {
    /**
     Provides the proper internal selector to call for the type of UIControlEvent
     passed in.
     
     * parameter event: The UIControlEvents option to grab for the selector
     
     * returns: The selector
     */
    fileprivate func selectorSignature(for event: UIControl.Event) -> Selector? {
        switch event {
        case UIControl.Event.touchDown:
            return #selector(touchDown(sender:event:))
        case UIControl.Event.touchDownRepeat:
            return #selector(touchDownRepeat(sender:event:))
        case UIControl.Event.touchDragInside:
            return #selector(touchDragInside(sender:event:))
        case UIControl.Event.touchDragOutside:
            return #selector(touchDragOutside(sender:event:))
        case UIControl.Event.touchDragEnter:
            return #selector(touchDragEnter(sender:event:))
        case UIControl.Event.touchDragExit:
            return #selector(touchDragExit(sender:event:))
        case UIControl.Event.touchUpInside:
            return #selector(touchUpInside(sender:event:))
        case UIControl.Event.touchUpOutside:
            return #selector(touchUpOutside(sender:event:))
        case UIControl.Event.touchCancel:
            return #selector(touchCancel(sender:event:))
        case UIControl.Event.valueChanged:
            return #selector(valueChanged(sender:event:))
        case UIControl.Event.primaryActionTriggered:
            return #selector(primaryActionTriggered(sender:event:))
        case UIControl.Event.editingDidBegin:
            return #selector(editingDidBegin(sender:event:))
        case UIControl.Event.editingChanged:
            return #selector(editingChanged(sender:event:))
        case UIControl.Event.editingDidEnd:
            return #selector(editingDidEnd(sender:event:))
        case UIControl.Event.editingDidEndOnExit:
            return #selector(editingDidEndOnExit(sender:event:))
        case UIControl.Event.allTouchEvents:
            return #selector(allTouchEvents(sender:event:))
        case UIControl.Event.allEditingEvents:
            return #selector(allEditingEvents(sender:event:))
        case UIControl.Event.applicationReserved:
            return #selector(applicationReserved(sender:event:))
        case UIControl.Event.systemReserved:
            return #selector(systemReserved(sender:event:))
        case UIControl.Event.allEvents:
            return #selector(allEvents(sender:event:))
        default:
            return nil
        }
    }
}

extension UIButton {
    // MARK: Common Events
    /**
     A convenience method wrapping a typical use for UIButton's
     UIControlEvents.touchUpInside event. This allows a parameterless
     closure to be called when the UIButton is tapped.
     
     * * * *
     #### An example of calling this method:
     ```swift
     myButton.onTap {
         <# button tapped code #>
     }
     ```
     
     * parameter handler: The closure to be called on the button tapped event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onTap(handler: @escaping () -> Void) -> Self {
        on(.touchUpInside) { _,_ in
            handler()
        }
        return self
    }
}

extension UITextField {
    // MARK: Common Events
    /**
     A convenience method wrapping a typical use for UITextField's
     UIControlEvents.editingChanged event. This will send the new
     value `text` after it has been modified.
     
     * * * *
     #### An example of calling this method:
     ```swift
     myTextField.onChange { newText in
         <#text changed code#>
     }
     ```
     * Note:
     This callback provides a non-optional String, even though UITextField.text can be `nil`.
     For that reason, it is technically not exactly the text in the `text` property, but
     rather a convenience so you don't have to unwrap it. If `nil` is an important distinction
     for you to have, please use the text field's `text` property directly or use
     `on(_:handler:)` and obtain the `text` property from the sender parameter.
     
     * parameter handler: The closure to be called on the text changed event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onChange(handler: @escaping (_ text: String) -> Void) -> Self {
        on(.editingChanged) { sender, _ in
            guard let textField = sender as? UITextField, let text = textField.text else {
                handler("")
                return
            }
            handler(text)
        }
        return self
    }
    
    /**
     A convenience method to respond to UIControlEvents.editingDidEnd for a UITextField.
     This occurs when the UITextField resigns as first responder.
     
     * parameter handler: The closure to be called when the focus leaves the text field
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onEditingEnded(handler: @escaping () -> Void) -> Self {
        on(.editingDidEnd) { _,_ in
            handler()
        }
        return self
    }
    
    /**
     A convenience method to respond to UIControlEvents.editingDidBegin for a UITextField.
     This occurs when the UITextField becomes the first responder.
     
     * parameter handler: The closure to be called when the focus enters the text field
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onEditingBegan(handler: @escaping () -> Void) -> Self {
        on(.editingDidBegin) { _,_ in
            handler()
        }
        return self
    }
    
    /**
     A convenience method to respond to UIControlEvents.editingDidEndOnExit for a UITextField.
     This occurs when the user taps the return key on the keyboard.
     
     * parameter handler: The closure to be called when the return key is tapped
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onReturn(handler: @escaping () -> Void) -> Self {
        on(.editingDidEndOnExit) { _,_ in
            handler()
        }
        return self
    }
}

extension UITextField {
    // MARK: Delegate Overrides
    /**
     This method determines if the text field should begin editing. This is equivalent 
     to implementing the textFieldShouldBeginEditing(_:) method in UITextFieldDelegate.
     
     * parameter handler: The closure that determines whether the text field should begin editing.
     
     * returns: Returns itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldBeginEditing(handler: @escaping () -> Bool) -> Self {
        return update { $0.shouldBeginEditing = handler }
    }
    
    /**
     This method determines if the text field did begin editing. This is equivalent
     to implementing the textFieldDidBeginEditing(_:) method in UITextFieldDelegate.
     
     * parameter handler: The closure that determines whether the text field did begin editing.
     
     * returns: Returns itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didBeginEditing(handler: @escaping () -> Void) -> Self {
        return update { $0.didBeginEditing = handler }
    }
    
    /**
     This method determines if the text field should end editing. This is equivalent
     to implementing the textFieldShouldEndEditing(_:) method in UITextFieldDelegate.
     
     * parameter handler: The closure that determines whether the text field should end editing.
     
     * returns: Returns itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldEndEditing(handler: @escaping () -> Bool) -> Self {
        return update { $0.shouldEndEditing = handler }
    }
    
    /**
     This method determines if the text field did end editing. This is equivalent
     to implementing the textFieldDidEndEditing(_:) method in UITextFieldDelegate.
     
     * parameter handler: The closure that determines whether the text field did end editing.
     
     * returns: Returns itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndEditing(handler: @escaping () -> Void) -> Self {
        return update { $0.didEndEditing = handler }
    }
    
    /**
     This method determines if the text field should change its characters based on user input.
     This is equivalent to implementing the textField(_:shouldChangeCharactersIn:replacementString:) 
     method in UITextFieldDelegate. This closure passed here will conflict with any closure 
     passed to `shouldChangeString(handler:)` and the last closure passed will be the one that's called.
     
     * parameter handler: The closure that determines whether the text field should change its characters.
     
     * returns: Returns itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldChangeCharacters(handler: @escaping (_ range: NSRange, _ replacementString: String) -> Bool) -> Self {
        return update { $0.shouldChangeCharacters = handler }
    }
    
    /**
     This method determines if the text field should change its text based on user input.
     This is a convenience method around equivalent to implementing the 
     textField(_:shouldChangeCharactersIn:replacementString:) method in UITextFieldDelegate.
     This closure passed here will conflict with any closure passed to `shouldChangeCharacters(_:)`
     and the last closure passed will be the one that's called.
     
     * parameter handler: The closure that determines whether the text field should change its text `from` 
     the first parameter string `to` the second parameter string.
     
     * returns: Returns itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldChangeString(handler: @escaping (_ from: String, _ to: String) -> Bool) -> Self {
        return shouldChangeCharacters() { [weak self] range, string in
            guard let strongSelf = self,
                let text = strongSelf.text else {
                    return true
            }
            let newString = NSString(string: text).replacingCharacters(in: range, with: string)
            return handler(text, newString)
        }
    }
    
    /**
     This method determines if the text field should remove its text. This is equivalent
     to implementing the textFieldShouldClear(_:) method in UITextFieldDelegate.
     
     * parameter handler: The closure that determines whether the text field should clear its text.
     
     * returns: Returns itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldClear(handler: @escaping () -> Bool) -> Self {
        return update { $0.shouldClear = handler }
    }
    
    /**
     This method determines if the text field should process the return button. This is equivalent
     to implementing the textFieldShouldReturn(_:) method in UITextFieldDelegate.
     
     * parameter handler: The closure that determines whether the text field should process the return button.
     
     * returns: Returns itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldReturn(handler: @escaping () -> Bool) -> Self {
        return update { $0.shouldReturn = handler }
    }
}

extension UITextField: DelegatorProtocol {
    @discardableResult
    fileprivate func update(handler: (_ delegate: TextFieldDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: TextFieldDelegate(),
                               delegates: &TextFieldDelegate.delegates,
                               bind: UITextField.bind) {
                                handler($0.delegate)
        }
        return self
    }
    
    // MARK: Reset
    /**
     Clears any delegate closures that were assigned to this
     `UITextField`. This cleans up memory as well as sets the
     delegate property to nil. This is typically only used for explicit
     cleanup. You are not required to call this method.
     */
    @objc public func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &TextFieldDelegate.delegates)
        UITextField.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: UITextField, _ delegate: TextFieldDelegate?) {
        delegator.delegate = nil
        delegator.delegate = delegate
    }
}

#if DEBUG
var textFieldDelegates: Set<AnyHashable> {
    return TextFieldDelegate.delegates
}
#endif

fileprivate final class TextFieldDelegate: NSObject, UITextFieldDelegate, DelegateProtocol {
    fileprivate static var delegates = Set<DelegateWrapper<UITextField, TextFieldDelegate>>()
    
    override required init() {
        super.init()
    }
    
    fileprivate var shouldBeginEditing: (() -> Bool)?
    fileprivate func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return shouldBeginEditing?() ?? true
    }
    
    fileprivate var didBeginEditing: (() -> Void)?
    fileprivate func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?()
    }
    
    fileprivate var shouldEndEditing: (() -> Bool)?
    fileprivate func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return shouldEndEditing?() ?? true
    }
    
    fileprivate var didEndEditing: (() -> Void)?
    fileprivate func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?()
    }
    
    fileprivate var shouldChangeCharacters: (( _ range: NSRange, _ replacementString: String) -> Bool)?
    fileprivate func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return shouldChangeCharacters?(range, string) ?? true
    }
    
    fileprivate var shouldClear: (() -> Bool)?
    fileprivate func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return shouldClear?() ?? true
    }
    
    fileprivate var shouldReturn: (() -> Bool)?
    fileprivate func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        return shouldReturn?() ?? true
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(TextFieldDelegate.textFieldShouldBeginEditing(_:)):
            return shouldBeginEditing != nil
        case #selector(TextFieldDelegate.textFieldDidBeginEditing(_:)):
            return didBeginEditing != nil
        case #selector(TextFieldDelegate.textFieldShouldEndEditing(_:)):
            return shouldEndEditing != nil
        case #selector(TextFieldDelegate.textFieldDidEndEditing(_:)):
            return didEndEditing != nil
        case #selector(TextFieldDelegate.textField(_:shouldChangeCharactersIn:replacementString:)):
            return shouldChangeCharacters != nil
        case #selector(TextFieldDelegate.textFieldShouldClear(_:)):
            return shouldClear != nil
        case #selector(TextFieldDelegate.textFieldShouldReturn(_:)):
            return shouldReturn != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

extension UISwitch {
    // MARK: Common Events
    /**
     A convenience method wrapping the .onValueChanged event
     type for UISwitch.
     
     * parameter handler: The closure to be called on the valueChanged event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onChange(handler: @escaping (_ value: Bool) -> Void) -> Self {
        _onChange(callerHandler: handler, valueHandler: { (uiSwitch: UISwitch) -> Bool in
            return uiSwitch.isOn
        })
        return self
    }
}

extension UISlider {
    // MARK: Common Events
    /**
     A convenience method wrapping the .onValueChanged event
     type for UISlider.
     
     * parameter handler: The closure to be called on the valueChanged event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onChange(handler: @escaping (_ value: Float) -> Void) -> Self {
        _onChange(callerHandler: handler, valueHandler: { (slider: UISlider) -> Float in
            return slider.value
        })
        return self
    }
}

extension UISegmentedControl {
    // MARK: Common Events
    /**
     A convenience method wrapping the .onValueChanged event
     type for UISegmentedControl.
     
     * parameter handler: The closure to be called on the valueChanged event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onChange(handler: @escaping (_ value: Int) -> Void) -> Self {
        _onChange(callerHandler: handler, valueHandler: { (segmented: UISegmentedControl) -> Int in
            return segmented.selectedSegmentIndex
        })
        return self
    }
}

extension UIStepper {
    // MARK: Common Events
    /**
     A convenience method wrapping the .onValueChanged event
     type for UIStepper.
     
     * parameter handler: The closure to be called on the valueChanged event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onChange(handler: @escaping (_ value: Double) -> Void) -> Self {
        _onChange(callerHandler: handler, valueHandler: { (stepper: UIStepper) -> Double in
            return stepper.value
        })
        return self
    }
}

extension UIPageControl {
    // MARK: Common Events
    /**
     A convenience method wrapping the .onValueChanged event
     type for UIPageControl.
     
     * parameter handler: The closure to be called on the valueChanged event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onChange(handler: @escaping (_ value: Int) -> Void) -> Self {
        _onChange(callerHandler: handler, valueHandler: { (pager: UIPageControl) -> Int in
            return pager.currentPage
        })
        return self
    }
}

extension UIDatePicker {
    // MARK: Common Events
    /**
     A convenience method wrapping the .onValueChanged event
     type for UIDatePicker.
     
     * parameter handler: The closure to be called on the valueChanged event
     
     * returns: itself so you can daisy chain the other event handler calls
     */
    @discardableResult
    public func onChange(handler: @escaping (_ value: Date) -> Void) -> Self {
        _onChange(callerHandler: handler, valueHandler: { (picker: UIDatePicker) -> Date in
            return picker.date
        })
        return self
    }
}
