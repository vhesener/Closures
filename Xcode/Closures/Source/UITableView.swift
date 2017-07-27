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

/// :nodoc:
private let jzyBug = 0 // Prevent the license header from showing up in Jazzy Docs for UITableView

extension UITableView {
    // MARK: Common Array Usage
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UITableView when using an `Array` as a data source.
     The defaults that this method takes care of:
     
     * Registers the cell's class and reuse identifier with a default value
     * Optionally uses a cellNibName value to create the cell from a nib file
     from the main bundle
     * Handles cell dequeueing and provides a reference to the cell
     in the `row` closure for you to modify in place.
     * Provides the number of sections
     * Provides the number of rows
     
     This method simply sets basic default behavior. This means that you can
     override the default table view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfSectionsIn` callback, for instance, the closure
     you passed into `numberOfSectionsIn` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you
     call reloadData(). If you have a lot of table view customization in addtion to a lot
     of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * * * *
     #### An example of calling this method:
     ```swift
     tableView.addElements(<#myArray#>, cell: <#MyUITableViewCellClass#>.self) { element, cell, index in
         cell.textLabel!.text = <#T##someString(from: element)##String#>
     }
     ```
     * parameter array: An Array to be used for each row.
     * parameter cell: A type of cell to use when calling `dequeueReusableCell(withIdentifier:for:)`
     * parameter cellNibName: If non-nil, the cell will be dequeued using a nib with this name from the main bundle
     * parameter row: A closure that's called when a cell is about to be shown and needs to be configured.
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func addElements<Element,Cell>(
        _ elements: [Element],
        cell: Cell.Type,
        cellNibName: String? = nil,
        row: @escaping (_ element: Element, _ cell: inout Cell,_ index: Int) -> Void) -> Self
        where Cell: UITableViewCell {
            return addSections([elements], cell: cell, cellNibName: cellNibName, row: row)
    }
    
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UITableView when using an `Array` as a data source.
     The defaults that this method takes care of:
     
     * Registers the cell's class and reuse identifier with a default value
     * Optionally uses a cellNibName value to create the cell from a nib file
     from the main bundle
     * Handles cell dequeueing and provides a reference to the cell
     in the `row` closure for you to modify in place.
     * Provides the number of sections
     * Provides the number of rows
     * Calls the headerView handler when each section title view needs to be shown.
     
     This method simply sets basic default behavior. This means that you can
     override the default table view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfSectionsIn` callback, for instance, the closure
     you passed into `numberOfSectionsIn` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you
     call reloadData(). If you have a lot of table view customization in addtion to a lot
     of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * * * *
     #### An example of calling this method:
     ```swift
     tableView.addSections(
         <#my2dArray#>,
         cell: <#MyUITableViewCellClass#>.self,
         headerView: { array, index in
             <#T##aView(from: array)##UIView#>},
         row: { element, cell, index in
             cell.textLabel!.text = <#T##someString(from: element)##String#>}
     )
     ```
     * parameter array: A two dimensional `Array` to be used for each section.
     * parameter cell: A type of cell to use when calling `dequeueReusableCell(withIdentifier:for:)`
     * parameter cellNibName: If non-nil, the cell will be dequeued using a nib with this name from the main bundle
     * parameter headerView: A closure that provides the information needed to display the section's header
     as an instance of `UIView`.
     * parameter row: A closure that's called when a cell is about to be shown and needs to be configured.
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func addSections<Element,Cell>(
        _ elements: [[Element]],
        cell: Cell.Type,
        cellNibName: String? = nil,
        headerView: @escaping ((_ elements: [Element], _ index: Int) -> UIView),
        row: @escaping (_ element: Element, _ cell: inout Cell,_ index: Int) -> Void) -> Self
        where Cell: UITableViewCell {
            
            return _addSections(elements, cell: cell, cellNibName: cellNibName, row: row)
                .viewForHeaderInSection() {
                    return headerView(elements[$0], $0)
            }
    }
    
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UITableView when using an `Array` as a data source.
     The defaults that this method takes care of:
     
     * Registers the cell's class and reuse identifier with a default value
     * Optionally uses a cellNibName value to create the cell from a nib file
     from the main bundle
     * Handles cell dequeueing and provides a reference to the cell
     in the `row` closure for you to modify in place.
     * Provides the number of sections
     * Provides the number of rows
     * Calls the headerView handler when each section title view needs to be shown.
     
     This method simply sets basic default behavior. This means that you can
     override the default table view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfSectionsIn` callback, for instance, the closure
     you passed into `numberOfSectionsIn` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you
     call reloadData(). If you have a lot of table view customization in addtion to a lot
     of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * * * *
     #### An example of calling this method:
     ```swift
     tableView.addSections(
         <#my2dArray#>,
         cell: <#MyUITableViewCellClass#>.self,
         headerTitle: { array, index in
         <#T##aTitle(from: array)##String#>},
         row: { element, cell, index in
             cell.textLabel!.text = <#T##someString(from: element)##String#>}
     )
     ```
     * parameter array: A two dimensional `Array` to be used for each section.
     * parameter cell: A type of cell to use when calling `dequeueReusableCell(withIdentifier:for:)`
     * parameter cellNibName: If non-nil, the cell will be dequeued using a nib with this name from the main bundle
     * parameter headerTitle: A closure that provides the information needed to display the section's header
     as a `String`.
     * parameter row: A closure that's called when a cell is about to be shown and needs to be configured.
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func addSections<Element,Cell>(
        _ elements: [[Element]],
        cell: Cell.Type,
        cellNibName: String? = nil,
        headerTitle: ((_ elements: [Element], _ index: Int) -> String)? = nil,
        row: @escaping (_ element: Element, _ cell: inout Cell,_ index: Int) -> Void) -> Self
        where Cell: UITableViewCell {
            
            _addSections(elements, cell: cell, cellNibName: cellNibName, row: row)
            if let headerTitle = headerTitle {
                titleForHeaderInSection {headerTitle(elements[$0], $0)}
            }
            return self
    }
    
    @discardableResult
    private func _addSections<Element,Cell>(
        _ elements: [[Element]],
        cell: Cell.Type,
        cellNibName: String? = nil,
        row: @escaping (_ element: Element, _ cell: inout Cell,_ index: Int) -> Void) -> Self
        where Cell: UITableViewCell {
            
            DelegateWrapper.remove(delegator: self, from: &TableViewDelegate.delegates)
            delegate = nil
            dataSource = nil
            let reuseIdentifier = "\(Element.self).\(cell)"
            
            if let nibName = cellNibName {
                register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            } else {
                register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
            }
            
            return numberOfSectionsIn
                {
                    return elements.count
                }.numberOfRows {
                    return elements[$0].count
                }.cellForRow { [unowned self] in
                    let element = elements[$0.section][$0.row]
                    var cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: $0) as! Cell
                    row(element, &cell, $0.row)
                    return cell
            }
    }
}

class TableViewDelegate: ScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    fileprivate static var delegates = Set<DelegateWrapper<UITableView, TableViewDelegate>>()
    
    fileprivate var willDisplay: ((_ cell: UITableViewCell, _ forRowAt: IndexPath) -> Void)?
    fileprivate var willDisplayHeaderView: ((_ view: UIView, _ forSection: Int) -> Void)?
    fileprivate var willDisplayFooterView: ((_ view: UIView, _ section: Int) -> Void)?
    fileprivate var didEndDisplaying: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?
    fileprivate var didEndDisplayingHeaderView: ((_ view: UIView, _ section: Int) -> Void)?
    fileprivate var didEndDisplayingFooterView: ((_ view: UIView, _ section: Int) -> Void)?
    fileprivate var heightForRowAt: ((_ indexPath: IndexPath) -> CGFloat)?
    fileprivate var heightForHeaderInSection: ((_ section: Int) -> CGFloat)?
    fileprivate var heightForFooterInSection: ((_ section: Int) -> CGFloat)?
    fileprivate var estimatedHeightForRowAt: ((_ indexPath: IndexPath) -> CGFloat)?
    fileprivate var estimatedHeightForHeaderInSection: ((_ section: Int) -> CGFloat)?
    fileprivate var estimatedHeightForFooterInSection: ((_ section: Int) -> CGFloat)?
    fileprivate var viewForHeaderInSection: ((_ section: Int) -> UIView?)?
    fileprivate var viewForFooterInSection: ((_ section: Int) -> UIView?)?
    fileprivate var accessoryButtonTappedForRowWith: ((_ indexPath: IndexPath) -> Void)?
    fileprivate var shouldHighlightRowAt: ((_ indexPath: IndexPath) -> Bool)?
    fileprivate var didHighlightRowAt: ((_ indexPath: IndexPath) -> Void)?
    fileprivate var didUnhighlightRowAt: ((_ indexPath: IndexPath) -> Void)?
    fileprivate var willSelectRowAt: ((_ indexPath: IndexPath) -> IndexPath?)?
    fileprivate var willDeselectRowAt: ((_ indexPath: IndexPath) -> IndexPath?)?
    fileprivate var didSelectRowAt: ((_ indexPath: IndexPath) -> Void)?
    fileprivate var didDeselectRowAt: ((_ indexPath: IndexPath) -> Void)?
    fileprivate var editingStyleForRowAt: ((_ indexPath: IndexPath) -> UITableViewCellEditingStyle)?
    fileprivate var titleForDeleteConfirmationButtonForRowAt: ((_ indexPath: IndexPath) -> String?)?
    fileprivate var editActionsForRowAt: ((_ indexPath: IndexPath) -> [UITableViewRowAction]?)?
    fileprivate var shouldIndentWhileEditingRowAt: ((_ indexPath: IndexPath) -> Bool)?
    fileprivate var willBeginEditingRowAt: ((_ indexPath: IndexPath) -> Void)?
    fileprivate var didEndEditingRowAt: ((_ indexPath: IndexPath?) -> Void)?
    fileprivate var targetIndexPathForMoveFromRowAt: ((_ sourceIndexPath: IndexPath, _ proposedDestinationIndexPath: IndexPath) -> IndexPath)?
    fileprivate var indentationLevelForRowAt: ((_ indexPath: IndexPath) -> Int)?
    fileprivate var shouldShowMenuForRowAt: ((_ indexPath: IndexPath) -> Bool)?
    fileprivate var canPerformAction: ((_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool)?
    fileprivate var performAction: ((_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Void)?
    fileprivate var canFocusRowAt: ((_ indexPath: IndexPath) -> Bool)?
    fileprivate var shouldUpdateFocus: ((_ context: UITableViewFocusUpdateContext) -> Bool)?
    fileprivate var didUpdateFocus: ((_ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)?
    fileprivate var indexPathForPreferredFocusedView: (() -> IndexPath?)?
    fileprivate var numberOfRows: ((_ section: Int) -> Int)?
    fileprivate var cellForRow: ((_ indexPath: IndexPath) -> UITableViewCell)?
    fileprivate var numberOfSections: (() -> Int)?
    fileprivate var titleForHeaderInSection: ((_ section: Int) -> String?)?
    fileprivate var titleForFooterInSection: ((_ section: Int) -> String?)?
    fileprivate var canEditRowAt: ((_ indexPath: IndexPath) -> Bool)?
    fileprivate var canMoveRowAt: ((_ indexPath: IndexPath) -> Bool)?
    fileprivate var sectionIndexTitles: (() -> [String]?)?
    fileprivate var sectionForSectionIndexTitle: ((_ title: String, _ index: Int) -> Int)?
    fileprivate var commit: ((_ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> Void)?
    fileprivate var moveRowAt: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    private var _leadingSwipeActionsConfigurationForRowAt: Any?
    @available(iOS 11, *)
    fileprivate var leadingSwipeActionsConfigurationForRowAt: ((_ indexPath: IndexPath) -> UISwipeActionsConfiguration?)? {
        get {
            return _leadingSwipeActionsConfigurationForRowAt as? (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?
        }
        set {
            _leadingSwipeActionsConfigurationForRowAt = newValue
        }
    }
    private var _trailingSwipeActionsConfigurationForRowAt: Any?
    @available(iOS 11, *)
    fileprivate var trailingSwipeActionsConfigurationForRowAt: ((_ indexPath: IndexPath) -> UISwipeActionsConfiguration?)? {
        get {
            return _trailingSwipeActionsConfigurationForRowAt as? (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?
        }
        set {
            _trailingSwipeActionsConfigurationForRowAt = newValue
        }
    }
    private var _shouldSpringLoadRowAt: Any?
    @available(iOS 11, *)
    fileprivate var shouldSpringLoadRowAt: ((_ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool)? {
        get {
            return _shouldSpringLoadRowAt as? (_ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool
        }
        set {
            _shouldSpringLoadRowAt = newValue
        }
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if #available(iOS 11, *) {
            switch aSelector {
            case #selector(TableViewDelegate.tableView(_:leadingSwipeActionsConfigurationForRowAt:)):
                return _leadingSwipeActionsConfigurationForRowAt != nil
            case #selector(TableViewDelegate.tableView(_:trailingSwipeActionsConfigurationForRowAt:)):
                return _trailingSwipeActionsConfigurationForRowAt != nil
            case #selector(TableViewDelegate.tableView(_:shouldSpringLoadRowAt:with:)):
                return _shouldSpringLoadRowAt != nil
            default:
                break
            }
        }
        
        switch aSelector {
        case #selector(TableViewDelegate.tableView(_:willDisplay:forRowAt:)):
            return willDisplay != nil
        case #selector(TableViewDelegate.tableView(_:willDisplayHeaderView:forSection:)):
            return willDisplayHeaderView != nil
        case #selector(TableViewDelegate.tableView(_:willDisplayFooterView:forSection:)):
            return willDisplayFooterView != nil
        case #selector(TableViewDelegate.tableView(_:didEndDisplaying:forRowAt:)):
            return didEndDisplaying != nil
        case #selector(TableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:)):
            return didEndDisplayingHeaderView != nil
        case #selector(TableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:)):
            return didEndDisplayingFooterView != nil
        case #selector(TableViewDelegate.tableView(_:heightForRowAt:)):
            return heightForRowAt != nil
        case #selector(TableViewDelegate.tableView(_:heightForHeaderInSection:)):
            return heightForHeaderInSection != nil
        case #selector(TableViewDelegate.tableView(_:heightForFooterInSection:)):
            return heightForFooterInSection != nil
        case #selector(TableViewDelegate.tableView(_:estimatedHeightForRowAt:)):
            return estimatedHeightForRowAt != nil
        case #selector(TableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:)):
            return estimatedHeightForHeaderInSection != nil
        case #selector(TableViewDelegate.tableView(_:estimatedHeightForFooterInSection:)):
            return estimatedHeightForFooterInSection != nil
        case #selector(TableViewDelegate.tableView(_:viewForHeaderInSection:)):
            return viewForHeaderInSection != nil
        case #selector(TableViewDelegate.tableView(_:viewForFooterInSection:)):
            return viewForFooterInSection != nil
        case #selector(TableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:)):
            return accessoryButtonTappedForRowWith != nil
        case #selector(TableViewDelegate.tableView(_:shouldHighlightRowAt:)):
            return shouldHighlightRowAt != nil
        case #selector(TableViewDelegate.tableView(_:didHighlightRowAt:)):
            return didHighlightRowAt != nil
        case #selector(TableViewDelegate.tableView(_:didUnhighlightRowAt:)):
            return didUnhighlightRowAt != nil
        case #selector(TableViewDelegate.tableView(_:willSelectRowAt:)):
            return willSelectRowAt != nil
        case #selector(TableViewDelegate.tableView(_:willDeselectRowAt:)):
            return willDeselectRowAt != nil
        case #selector(TableViewDelegate.tableView(_:didSelectRowAt:)):
            return didSelectRowAt != nil
        case #selector(TableViewDelegate.tableView(_:didDeselectRowAt:)):
            return didDeselectRowAt != nil
        case #selector(TableViewDelegate.tableView(_:editingStyleForRowAt:)):
            return editingStyleForRowAt != nil
        case #selector(TableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:)):
            return titleForDeleteConfirmationButtonForRowAt != nil
        case #selector(TableViewDelegate.tableView(_:editActionsForRowAt:)):
            return editActionsForRowAt != nil
        case #selector(TableViewDelegate.tableView(_:shouldIndentWhileEditingRowAt:)):
            return shouldIndentWhileEditingRowAt != nil
        case #selector(TableViewDelegate.tableView(_:willBeginEditingRowAt:)):
            return willBeginEditingRowAt != nil
        case #selector(TableViewDelegate.tableView(_:didEndEditingRowAt:)):
            return didEndEditingRowAt != nil
        case #selector(TableViewDelegate.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:)):
            return targetIndexPathForMoveFromRowAt != nil
        case #selector(TableViewDelegate.tableView(_:indentationLevelForRowAt:)):
            return indentationLevelForRowAt != nil
        case #selector(TableViewDelegate.tableView(_:shouldShowMenuForRowAt:)):
            return shouldShowMenuForRowAt != nil
        case #selector(TableViewDelegate.tableView(_:canPerformAction:forRowAt:withSender:)):
            return canPerformAction != nil
        case #selector(TableViewDelegate.tableView(_:canPerformAction:forRowAt:withSender:)):
            return performAction != nil
        case #selector(TableViewDelegate.tableView(_:canFocusRowAt:)):
            return canFocusRowAt != nil
        case #selector(TableViewDelegate.tableView(_:shouldUpdateFocusIn:)):
            return shouldUpdateFocus != nil
        case #selector(TableViewDelegate.tableView(_:didUpdateFocusIn:with:)):
            return didUpdateFocus != nil
        case #selector(TableViewDelegate.indexPathForPreferredFocusedView(in:)):
            return indexPathForPreferredFocusedView != nil
        case #selector(TableViewDelegate.tableView(_:numberOfRowsInSection:)):
            return true
        case #selector(TableViewDelegate.tableView(_:cellForRowAt:)):
            return true
        case #selector(TableViewDelegate.numberOfSections(in:)):
            return true
        case #selector(TableViewDelegate.tableView(_:titleForHeaderInSection:)):
            return titleForHeaderInSection != nil
        case #selector(TableViewDelegate.tableView(_:titleForFooterInSection:)):
            return titleForFooterInSection != nil
        case #selector(TableViewDelegate.tableView(_:canEditRowAt:)):
            return canEditRowAt != nil
        case #selector(TableViewDelegate.tableView(_:canMoveRowAt:)):
            return canMoveRowAt != nil
        case #selector(TableViewDelegate.tableView(_:sectionForSectionIndexTitle:at:)):
            return sectionIndexTitles != nil
        case #selector(TableViewDelegate.tableView(_:sectionForSectionIndexTitle:at:)):
            return sectionForSectionIndexTitle != nil
        case #selector(TableViewDelegate.tableView(_:commit:forRowAt:)):
            return commit != nil
        case #selector(TableViewDelegate.tableView(_:moveRowAt:to:)):
            return moveRowAt != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

extension TableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay?(cell, indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeaderView?(view, section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooterView?(view, section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplaying?(cell, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        didEndDisplayingHeaderView?(view, section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        didEndDisplayingFooterView?(view, section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAt?(indexPath) ??  tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection?(section) ??  0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection?(section) ??  0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeightForRowAt?(indexPath) ??  UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedHeightForHeaderInSection?(section) ??  0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedHeightForFooterInSection?(section) ??  0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection?(section) ??  nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection?(section) ??  nil
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        accessoryButtonTappedForRowWith?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return shouldHighlightRowAt?(indexPath) ??  true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        didHighlightRowAt?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        didUnhighlightRowAt?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return willSelectRowAt?(indexPath) ??  indexPath
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return willDeselectRowAt?(indexPath) ??  indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRowAt?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return editingStyleForRowAt?(indexPath) ??  .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return titleForDeleteConfirmationButtonForRowAt?(indexPath) ??  Bundle(identifier: "com.apple.UIKit")?.localizedString(forKey: "Delete", value: nil, table: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?  {
        return editActionsForRowAt?(indexPath) ??  nil
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return shouldIndentWhileEditingRowAt?(indexPath) ??  true
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        willBeginEditingRowAt?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        didEndEditingRowAt?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return targetIndexPathForMoveFromRowAt?(sourceIndexPath, proposedDestinationIndexPath) ??  proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return indentationLevelForRowAt?(indexPath) ??  0
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return shouldShowMenuForRowAt?(indexPath) ??  false
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return canPerformAction?(action, indexPath, sender) ??  false
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        performAction?(action, indexPath, sender)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return canFocusRowAt?(indexPath) ??  true
    }
    
    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return shouldUpdateFocus?(context) ??  true
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        didUpdateFocus?(context, coordinator)
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return indexPathForPreferredFocusedView?()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows?(section) ??  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow?(indexPath) ??  UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections?() ?? 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection?(section) ??  nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooterInSection?(section) ??  nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRowAt?(indexPath) ??  true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveRowAt?(indexPath) ??  true
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles?() ?? nil
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionForSectionIndexTitle?(title, index) ??  0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        commit?(editingStyle, indexPath)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRowAt?(sourceIndexPath, destinationIndexPath)
    }
    
    @available(iOS 11, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return leadingSwipeActionsConfigurationForRowAt?(indexPath)
    }
    
    @available(iOS 11, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return trailingSwipeActionsConfigurationForRowAt?(indexPath)
    }
    
    @available(iOS 11, *)
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return shouldSpringLoadRowAt?(indexPath, context) ?? true
    }
}

extension UITableView {
    // MARK: Delegate and DataSource Overrides
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:willDisplay:forRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willDisplay(handler: @escaping (_ cell: UITableViewCell, _ forRowAt: IndexPath) -> Void) -> Self {
        return update { $0.willDisplay = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:willDisplayHeaderView:forSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willDisplayHeaderView(handler: @escaping (_ view: UIView, _ forSection: Int) -> Void) -> Self {
        return update { $0.willDisplayHeaderView = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:willDisplayFooterView:forSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willDisplayFooterView(handler: @escaping (_ view: UIView, _ section: Int) -> Void) -> Self {
        return update { $0.willDisplayFooterView = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didEndDisplaying:forRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndDisplaying(handler: @escaping (_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didEndDisplaying = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didEndDisplayingHeaderView:forSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndDisplayingHeaderView(handler: @escaping (_ view: UIView, _ section: Int) -> Void) -> Self {
        return update { $0.didEndDisplayingHeaderView = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didEndDisplayingFooterView:forSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndDisplayingFooterView(handler: @escaping (_ view: UIView, _ section: Int) -> Void) -> Self {
        return update { $0.didEndDisplayingFooterView = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:heightForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func heightForRowAt(handler: @escaping (_ indexPath: IndexPath) -> CGFloat) -> Self {
        return update { $0.heightForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:heightForHeaderInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func heightForHeaderInSection(handler: @escaping (_ section: Int) -> CGFloat) -> Self {
        return update { $0.heightForHeaderInSection = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:heightForFooterInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func heightForFooterInSection(handler: @escaping (_ section: Int) -> CGFloat) -> Self {
        return update { $0.heightForFooterInSection = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:estimatedHeightForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func estimatedHeightForRowAt(handler: @escaping (_ indexPath: IndexPath) -> CGFloat) -> Self {
        return update { $0.estimatedHeightForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:estimatedHeightForHeaderInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func estimatedHeightForHeaderInSection(handler: @escaping (_ section: Int) -> CGFloat) -> Self {
        return update { $0.estimatedHeightForHeaderInSection = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:estimatedHeightForFooterInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func estimatedHeightForFooterInSection(handler: @escaping (_ section: Int) -> CGFloat) -> Self {
        return update { $0.estimatedHeightForFooterInSection = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:viewForHeaderInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func viewForHeaderInSection(handler: @escaping (_ section: Int) -> UIView?) -> Self {
        return update { $0.viewForHeaderInSection = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:viewForFooterInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func viewForFooterInSection(handler: @escaping (_ section: Int) -> UIView?) -> Self {
        return update { $0.viewForFooterInSection = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:accessoryButtonTappedForRowWith:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func accessoryButtonTappedForRowWith(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.accessoryButtonTappedForRowWith = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:shouldHighlightRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldHighlightRowAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.shouldHighlightRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didHighlightRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didHighlightRowAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didHighlightRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didUnhighlightRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didUnhighlightRowAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didUnhighlightRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:willSelectRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willSelectRowAt(handler: @escaping (_ indexPath: IndexPath) -> IndexPath?) -> Self {
        return update { $0.willSelectRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:willDeselectRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willDeselectRowAt(handler: @escaping (_ indexPath: IndexPath) -> IndexPath?) -> Self {
        return update { $0.willDeselectRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didSelectRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didSelectRowAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didSelectRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didDeselectRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didDeselectRowAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didDeselectRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:editingStyleForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func editingStyleForRowAt(handler: @escaping (_ indexPath: IndexPath) -> UITableViewCellEditingStyle) -> Self {
        return update { $0.editingStyleForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:titleForDeleteConfirmationButtonForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func titleForDeleteConfirmationButtonForRowAt(handler: @escaping (_ indexPath: IndexPath) -> String?) -> Self {
        return update { $0.titleForDeleteConfirmationButtonForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:editActionsForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func editActionsForRowAt(handler: @escaping (_ indexPath: IndexPath) -> [UITableViewRowAction]?) -> Self {
        return update { $0.editActionsForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:shouldIndentWhileEditingRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldIndentWhileEditingRowAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.shouldIndentWhileEditingRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:willBeginEditingRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willBeginEditingRowAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.willBeginEditingRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didEndEditingRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndEditingRowAt(handler: @escaping (_ indexPath: IndexPath?) -> Void) -> Self {
        return update { $0.didEndEditingRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func targetIndexPathForMoveFromRowAt(handler: @escaping (_ sourceIndexPath: IndexPath, _ proposedDestinationIndexPath: IndexPath) -> IndexPath) -> Self {
        return update { $0.targetIndexPathForMoveFromRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:indentationLevelForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func indentationLevelForRowAt(handler: @escaping (_ indexPath: IndexPath) -> Int) -> Self {
        return update { $0.indentationLevelForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:shouldShowMenuForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldShowMenuForRowAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.shouldShowMenuForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:canPerformAction:forRowAt:withSender:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func canPerformAction(handler: @escaping (_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        return update { $0.canPerformAction = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:performAction:forRowAt:withSender:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func performAction(handler: @escaping (_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Void) -> Self {
        return update { $0.performAction = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:canFocusRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func canFocusRowAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.canFocusRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:shouldUpdateFocusIn:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldUpdateFocus(handler: @escaping (_ context: UITableViewFocusUpdateContext) -> Bool) -> Self {
        return update { $0.shouldUpdateFocus = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:didUpdateFocusIn:with:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didUpdateFocus(handler: @escaping (_ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void) -> Self {
        return update { $0.didUpdateFocus = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's indexPathForPreferredFocusedView(in:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func indexPathForPreferredFocusedView(handler: @escaping () -> IndexPath?) -> Self {
        return update { $0.indexPathForPreferredFocusedView = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:numberOfRowsInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func numberOfRows(handler: @escaping (_ section: Int) -> Int) -> Self {
        return update { $0.numberOfRows = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:cellForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func cellForRow(handler: @escaping (_ indexPath: IndexPath) -> UITableViewCell) -> Self {
        return update { $0.cellForRow = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's numberOfSections(in:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func numberOfSectionsIn(handler: @escaping () -> Int) -> Self {
        return update { $0.numberOfSections = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:titleForHeaderInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func titleForHeaderInSection(handler: @escaping (_ section: Int) -> String?) -> Self {
        return update { $0.titleForHeaderInSection = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:titleForFooterInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func titleForFooterInSection(handler: @escaping (_ section: Int) -> String?) -> Self {
        return update { $0.titleForFooterInSection = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:canEditRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func canEditRowAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.canEditRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:canMoveRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func canMoveRowAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.canMoveRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's sectionIndexTitles(for:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func sectionIndexTitles(handler: @escaping () -> [String]?) -> Self {
        return update { $0.sectionIndexTitles = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:sectionForSectionIndexTitle:at:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func sectionForSectionIndexTitle(handler: @escaping (_ title: String, _ index: Int) -> Int) -> Self {
        return update { $0.sectionForSectionIndexTitle = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:commit:forRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func commit(handler: @escaping (_ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.commit = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDataSource's tableView(_:moveRowAt:to:) method
     
     * parameter handler: The closure that will be called in place of its equivalent datasource method
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func moveRowAt(handler: @escaping (_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void) -> Self {
        return update { $0.moveRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:leadingSwipeActionsConfigurationForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @available(iOS 11, *) @discardableResult
    public func leadingSwipeActionsConfigurationForRowAt(handler: @escaping (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        return update { $0.leadingSwipeActionsConfigurationForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:trailingSwipeActionsConfigurationForRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @available(iOS 11, *) @discardableResult
    public func trailingSwipeActionsConfigurationForRowAt(handler: @escaping (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        return update { $0.trailingSwipeActionsConfigurationForRowAt = handler }
    }
    
    /**
     Equivalent to implementing UITableViewDelegate's tableView(_:shouldSpringLoadRowAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @available(iOS 11, *) @discardableResult
    public func shouldSpringLoadRowAt(handler: @escaping (_ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) -> Self {
        return update { $0.shouldSpringLoadRowAt = handler }
    }
}

extension UITableView {
    @discardableResult
    @objc override func update(handler: (_ delegate: TableViewDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: TableViewDelegate(),
                               delegates: &TableViewDelegate.delegates,
                               bind: UITableView.bind) {
            handler($0.delegate)
        }
        return self
    }
    
    // MARK: Reset
    /**
     Clears any delegate/dataSource closures that were assigned to this
     `UITableView`. This cleans up memory as well as sets the
     delegate/dataSource properties to nil. This is typically only used for explicit
     cleanup. You are not required to call this method.
     */
    @objc override public func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &TableViewDelegate.delegates)
        UITableView.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: UITableView, _ delegate: TableViewDelegate?) {
        delegator.delegate = nil
        delegator.dataSource = nil
        delegator.delegate = delegate
        delegator.dataSource = delegate
    }
}
