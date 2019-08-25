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

@available(iOS 9.0, *)
fileprivate final class PickerViewDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource, DelegateProtocol {
    static var delegates = Set<DelegateWrapper<UIPickerView, PickerViewDelegate>>()
    
    fileprivate var rowHeightForComponent: ((_ component: Int) -> CGFloat)?
    fileprivate func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeightForComponent?(component) ?? 0
    }
    
    fileprivate var widthForComponent: ((_ component: Int) -> CGFloat)?
    fileprivate func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return widthForComponent?(component) ?? 0
    }
    
    fileprivate var titleForRow: ((_ row: Int, _ component: Int) -> String?)?
    fileprivate func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleForRow?(row, component)
    }
    
    fileprivate var attributedTitleForRow: ((_ row: Int, _ component: Int) -> NSAttributedString?)?
    fileprivate func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return attributedTitleForRow?(row, component)
    }
    
    fileprivate var viewForRow: ((_ row: Int, _ component: Int, _ reusingView: UIView?) -> UIView)?
    fileprivate func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return viewForRow?(row, component, view) ?? UIView()
    }
    
    fileprivate var didSelectRow: ((_ row: Int, _ component: Int) -> Void)?
    fileprivate func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectRow?(row, component)
    }
    
    fileprivate var numberOfComponents: (() -> Int)?
    fileprivate func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents?() ?? 1
    }
    
    fileprivate var numberOfRowsInComponent: ((_ component: Int) -> Int)?
    fileprivate func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfRowsInComponent?(component) ?? 0
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(PickerViewDelegate.pickerView(_:rowHeightForComponent:)):
            return rowHeightForComponent != nil
        case #selector(PickerViewDelegate.pickerView(_:widthForComponent:)):
            return widthForComponent != nil
        case #selector(PickerViewDelegate.pickerView(_:titleForRow:forComponent:)):
            return titleForRow != nil
        case #selector(PickerViewDelegate.pickerView(_:attributedTitleForRow:forComponent:)):
            return attributedTitleForRow != nil
        case #selector(PickerViewDelegate.pickerView(_:viewForRow:forComponent:reusing:)):
            return viewForRow != nil
        case #selector(PickerViewDelegate.pickerView(_:didSelectRow:inComponent:)):
            return didSelectRow != nil
        case #selector(PickerViewDelegate.numberOfComponents(in:)):
            return true
        case #selector(PickerViewDelegate.pickerView(_:numberOfRowsInComponent:)):
            return true
        default:
            return super.responds(to: aSelector)
        }
    }
}

@available(iOS 9.0, *)
extension UIPickerView {
    // MARK: Common Array Usage
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UIPickerView when using an `Array` as a data source.
     The defaults that this method takes care of:
     
     * Provides the number of components
     * Provides the number of rows
     * Handles the pickerView(_:didSelectRow:inComponent:) delegate method
     * Provides the title string for each row
     
     This method simply sets basic default behavior. This means that you can
     override the default picker view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfComponents` callback, for instance, the closure
     you passed into `numberOfComponents` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you call reloadComponent()
     or reloadAllComponents(). If you have a lot of picker view customization
     in addtion to a lot of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * * * *
     #### An example of calling this method:
     ```swift
     pickerView.addStrings(<#myArray#>) { aTitle,component,row in
         print("\(aTitle) was selected")
     }
     ```
     * parameter strings: An `Array` of `String`s to be used for each row in a single component picker view.
     * parameter didSelect: A closure that is called when the UIPickerView's value has been selected.
     
     * returns: itself so you can daisy chain the other delegate/datasource calls
     */
    @discardableResult
    public func addStrings(_ strings: [String],
                           didSelect: @escaping (_ element: String, _ component: Int, _ row: Int) -> Void) -> Self {
        return addComponents([strings], didSelect: didSelect)
    }
    
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UIPickerView when using an `Array` as a data source.
     The defaults that this method takes care of:
     
     * Provides the number of components
     * Provides the number of rows
     * Handles the pickerView(_:titleForRow:forComponent:) delegate method
     * Handles the pickerView(_:didSelectRow:inComponent:) delegate method
     
     This method simply sets basic default behavior. This means that you can
     override the default picker view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfComponents` callback, for instance, the closure
     you passed into `numberOfComponents` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you call reloadComponent()
     or reloadAllComponents(). If you have a lot of picker view customization
     in addtion to a lot of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * Important:
     Be sure to note that most of the closure callbacks in these array binding
     methods switch the order of the parameters of row and component. Most of the
     UIPickerView delegate/datasource method parameters have row,component. The
     handlers' parameters on the `add` methods send component,row.
     
     * * * *
     #### An example of calling this method:
     ```swift
     pickerView.addElements(
         <#myArray#>,
         rowTitle: { element, component, row in
             return <#aTitle(from: element)#>},
         didSelect: { element, component, row in
             print("\(element) was selected")
     )
     ```
     * parameter strings: An `Array` of any type to be used for each row in a single component picker view.
     * parameter rowTitle: A closure that is called when the UIPickerView needs to display a string for it's row.
     * parameter didSelect: A closure that is called when the UIPickerView's value has been selected.
     
     * returns: itself so you can daisy chain the other delegate/datasource calls
     */
    @discardableResult
    public func addElements<Element>(_ elements: [Element],
                                     rowTitle: @escaping (_ element: Element, _ component: Int, _ row: Int) -> String,
                                     didSelect: @escaping (_ element: Element, _ component: Int, _ row: Int) -> Void) -> Self {
        return addComponents([elements], rowTitle: rowTitle, didSelect: didSelect)
    }
    
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UIPickerView when using an `Array` as a data source.
     The defaults that this method takes care of:
     
     * Provides the number of components
     * Provides the number of rows
     * Handles the pickerView(_:viewForRow:forComponent:) delegate method
     * Handles the pickerView(_:didSelectRow:inComponent:) delegate method
     
     This method simply sets basic default behavior. This means that you can
     override the default picker view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfComponents` callback, for instance, the closure
     you passed into `numberOfComponents` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you call reloadComponent()
     or reloadAllComponents(). If you have a lot of picker view customization
     in addtion to a lot of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * Important:
     Be sure to note that most of the closure callbacks in these array binding
     methods switch the order of the parameters of row and component. Most of the
     UIPickerView delegate/datasource method parameters have row,component. The
     handlers' parameters on the `add` methods send component,row.
     
     * * * *
     #### An example of calling this method:
     ```swift
     pickerView.addElements(
         <#myArray#>,
         rowView: { element, reuseView, component, row in
             return <#aView(from: element)#>},
         didSelect: { element, component, row in
             print("\(element) was selected")
     )
     ```
     * parameter strings: An `Array` of any type to be used for each row in a single component picker view.
     * parameter rowView: A closure that is called when the UIPickerView needs to display a view for it's row.
     * parameter didSelect: A closure that is called when the UIPickerView's value has been selected.
     
     * returns: itself so you can daisy chain the other delegate/datasource calls
     */
    @discardableResult
    public func addElements<Element>(_ elements: [Element],
                                     rowView: @escaping (_ element: Element, _ reuseView: UIView?, _ component: Int, _ row: Int) -> UIView,
                                     didSelect: @escaping (_ element: Element, _ component: Int, _ row: Int) -> Void) -> Self {
        return addComponents([elements], rowView: rowView, didSelect: didSelect)
    }
    
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UIPickerView when using a two-dimensional Array as a data source.
     The defaults that this method takes care of:
     
     * Provides the number of components
     * Provides the number of rows
     * Handles the pickerView(_:didSelectRow:inComponent:) delegate method
     * Provides the title string for each row
     
     This method simply sets basic default behavior. This means that you can
     override the default picker view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfComponents` callback, for instance, the closure
     you passed into `numberOfComponents` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you call reloadComponent()
     or reloadAllComponents(). If you have a lot of picker view customization
     in addtion to a lot of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * * * *
     #### An example of calling this method:
     ```swift
     pickerView.addComponents(<#my2DArray#>) { aTitle,component,row in
         print("\(aTitle) was selected")
     }
     ```
     * parameter strings: An `Array` of `Array` of `String`s to be used for each row and component in a picker view.
     The outer dimension of the array is the component (columns) and the inner dimension are the rows in that component.
     e.g. myTwoDArray[component][row]
     * parameter didSelect: A closure that is called when the UIPickerView's value has been selected.
     
     * returns: itself so you can daisy chain the other delegate/datasource calls
     */
    @discardableResult
    public func addComponents(_ strings: [[String]],
                              didSelect: @escaping (_ element: String, _ component: Int, _ row: Int) -> Void) -> Self {
        return addComponents(strings, rowTitle: {e,_,_ in e}, didSelect: didSelect)
    }
    
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UIPickerView when using a two-dimensional Array as a data source.
     The defaults that this method takes care of:
     
     * Provides the number of components
     * Provides the number of rows
     * Handles the pickerView(_:titleForRow:forComponent:) delegate method
     * Handles the pickerView(_:didSelectRow:inComponent:) delegate method
     
     This method simply sets basic default behavior. This means that you can
     override the default picker view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfComponents` callback, for instance, the closure
     you passed into `numberOfComponents` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you call reloadComponent()
     or reloadAllComponents(). If you have a lot of picker view customization
     in addtion to a lot of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * Important:
     Be sure to note that most of the closure callbacks in these array binding
     methods switch the order of the parameters of row and component. Most of the
     UIPickerView delegate/datasource method parameters have row,component. The
     handlers' parameters on the `add` methods send component,row.
     
     * * * *
     #### An example of calling this method:
     ```swift
     pickerView.addComponents(
         <#my2DArray#>,
         rowTitle: { element, component, row in
             return <#aTitle(from: element, componentIdx: component)#>},
         didSelect: { element, component, row in
             print("\(element) was selected")
     )
     ```
     * parameter components: An `Array` of `Array` of any type to be used for each row and component in a picker view.
     The outer dimension of the array is the component (columns) and the inner dimension are the rows in that component.
     e.g. myTwoDArray[component][row]
     * parameter rowTitle: A closure that is called when the UIPickerView needs to display a string for it's row.
     * parameter didSelect: A closure that is called when the UIPickerView's value has been selected.
     
     * returns: itself so you can daisy chain the other delegate/datasource calls
     */
    @discardableResult
    public func addComponents<Element>(_ components: [[Element]],
                                       rowTitle: @escaping (_ element: Element, _ component: Int, _ row: Int) -> String,
                                       didSelect: @escaping (_ element: Element, _ component: Int, _ row: Int) -> Void) -> Self {
        return configureComponents(components, didSelect: didSelect).titleForRow() { rowIdx, componentIdx in
            rowTitle(components[componentIdx][rowIdx], componentIdx, rowIdx)
        }
    }
    
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UIPickerView when using a two-dimensional Array as a data source.
     The defaults that this method takes care of:
     
     * Provides the number of components
     * Provides the number of rows
     * Handles the pickerView(_:viewForRow:forComponent:) delegate method
     * Handles the pickerView(_:didSelectRow:inComponent:) delegate method
     
     This method simply sets basic default behavior. This means that you can
     override the default picker view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfComponents` callback, for instance, the closure
     you passed into `numberOfComponents` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you call reloadComponent()
     or reloadAllComponents(). If you have a lot of picker view customization
     in addtion to a lot of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * Important:
     Be sure to note that most of the closure callbacks in these array binding
     methods switch the order of the parameters of row and component. Most of the
     UIPickerView delegate/datasource method parameters have row,component. The
     handlers' parameters on the `add` methods send component,row.
     
     * * * *
     #### An example of calling this method:
     ```swift
     pickerView.addComponents(
         <#my2DArray#>,
         rowView: { element, reuseView, component, row in
             return <#aView(from: element, componentIdx: component)#>},
         didSelect: { element, component, row in
             print("\(element) was selected")
     )
     ```
     parameter components: An `Array` of `Array` of any type to be used for each row and component in a picker view.
     The outer dimension of the array is the component (columns) and the inner dimension are the rows in that component.
     e.g. myTwoDArray[component][row]
     * parameter rowView: A closure that is called when the UIPickerView needs to display a view for it's row.
     * parameter didSelect: A closure that is called when the UIPickerView's value has been selected.
     
     * returns: itself so you can daisy chain the other delegate/datasource calls
     */
    @discardableResult
    public func addComponents<Element>(_ components: [[Element]],
                                       rowView: @escaping (_ element: Element, _ reuseView: UIView?, _ component: Int, _ row: Int) -> UIView,
                                       didSelect: @escaping (_ element: Element, _ component: Int, _ row: Int) -> Void) -> Self {
        return configureComponents(components, didSelect: didSelect).viewForRow() { rowIdx, componentIdx, resuseView in
            rowView(components[componentIdx][rowIdx], resuseView, componentIdx, rowIdx)
        }
    }
    
    private func configureComponents<Element>(_ components: [[Element]],
                                              didSelect: @escaping (_ element: Element, _ component: Int, _ row: Int) -> Void) -> Self {
        DelegateWrapper.remove(delegator: self, from: &PickerViewDelegate.delegates)
        delegate = nil
        dataSource = nil
        
        return numberOfComponents
            {
                components.count
            }.numberOfRowsInComponent {
                components[$0].count
            }.didSelectRow() { rowIdx,componentIdx in
                didSelect(components[componentIdx][rowIdx], componentIdx, rowIdx)
        }
    }
}

@available(iOS 9.0, *)
extension UIPickerView {
    // MARK: Delegate and DataSource Overrides
    /**
     Equivalent to implementing UIPickerViewDelegate's pickerView(_:rowHeightForComponent:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func rowHeightForComponent(handler: @escaping (_ component: Int) -> CGFloat) -> Self {
        return update { $0.rowHeightForComponent = handler }
    }
    
    /**
     Equivalent to implementing UIPickerViewDelegate's pickerView(_:widthForComponent:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func widthForComponent(handler: @escaping (_ component: Int) -> CGFloat) -> Self {
        return update { $0.widthForComponent = handler }
    }
    
    /**
     Equivalent to implementing UIPickerViewDelegate's pickerView(_:titleForRow:forComponent:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func titleForRow(handler: @escaping (_ row: Int, _ component: Int) -> String?) -> Self {
        return update { $0.titleForRow = handler }
    }
    
    /**
     Equivalent to implementing UIPickerViewDelegate's pickerView(_:attributedTitleForRow:forComponent:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func attributedTitleForRow(handler: @escaping (_ row: Int, _ component: Int) -> NSAttributedString?) -> Self {
        return update { $0.attributedTitleForRow = handler }
    }
    
    /**
     Equivalent to implementing UIPickerViewDelegate's pickerView(_:viewForRow:forComponent:reusing:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func viewForRow(handler: @escaping (_ row: Int, _ component: Int, _ reusingView: UIView?) -> UIView) -> Self {
        return update { $0.viewForRow = handler }
    }
    
    /**
     Equivalent to implementing UIPickerViewDelegate's pickerView(_:didSelectRow:inComponent:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didSelectRow(handler: @escaping (_ row: Int, _ component: Int) -> Void) -> Self {
        return update { $0.didSelectRow = handler }
    }
    
    /**
     Equivalent to implementing UIPickerViewDataSource's numberOfComponents(in:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func numberOfComponents(handler: @escaping () -> Int) -> Self {
        return update { $0.numberOfComponents = handler }
    }
    
    /**
     Equivalent to implementing UIPickerViewDataSource's pickerView(_:numberOfRowsInComponent:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func numberOfRowsInComponent(handler: @escaping (_ component: Int) -> Int) -> Self {
        return update { $0.numberOfRowsInComponent = handler }
    }
}

@available(iOS 9.0, *)
extension UIPickerView: DelegatorProtocol {
    @discardableResult
    fileprivate func update(handler: (_ delegate: PickerViewDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: PickerViewDelegate(),
                               delegates: &PickerViewDelegate.delegates,
                               bind: UIPickerView.bind) {
                                handler($0.delegate)
        }
        return self
    }
    
    // MARK: Reset
    /**
     Clears any delegate/dataSource closures that were assigned to this
     `UIPickerView`. This cleans up memory as well as sets the
     delegate/dataSource properties to nil. This is typically only used for explicit
     cleanup. You are not required to call this method.
     */
    @objc public func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &PickerViewDelegate.delegates)
        UIPickerView.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: UIPickerView, _ delegate: PickerViewDelegate?) {
        delegator.delegate = nil
        delegator.dataSource = nil
        delegator.delegate = delegate
        delegator.dataSource = delegate
    }
}

