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
private let jzyBug = 0 // Prevent the license header from showing up in Jazzy Docs for UICollectionView

extension UICollectionView {
    // MARK: Common Array Usage
    /**
     This method defaults many of the boilerplate callbacks needed to populate a
     UICollectionView when using an `Array` as a data source.
     The defaults that this method takes care of:
     
     * Registers the cell's class and reuse identifier with a default value
     * Optionally uses a cellNibName value to create the cell from a nib file
     from the main bundle
     * Handles cell dequeueing and provides a reference to the cell
     in the `item` closure for you to modify in place.
     * Provides the number of sections
     * Provides the number of items
     
     This method simply sets basic default behavior. This means that you can
     override the default collection view handlers after this method is called.
     However, remember that order matters. If you call this method after you
     override the `numberOfSectionsIn` callback, for instance, the closure
     you passed into `numberOfSectionsIn` will be wiped out by this method
     and you will have to override that closure handler again.
     
     * Important:
     Please remember that Swift `Array`s are value types. This means that they
     are copied when mutaded. When the values or sequence of your array changes, you will
     need to call this method again, just before you
     call reloadData(). If you have a lot of collection view customization in addtion to a lot
     of updates to your array, it is more appropriate to use the individual
     closure handlers instead of this method.
     
     * * * *
     #### An example of calling this method:
     ```swift
     collectionView.addFlowElements(<#myArray#>, cell: <#MyUICollectionViewCellClass#>) { element, cell, index in
         cell.imageView.image = <#T##someImage(from: element)##UIImage#>
     }
     ```
     * parameter array: An Array to be used for each item.
     * parameter cell: A type of cell to use when calling `dequeueReusableCell(withReuseIdentifier:for:)`
     * parameter cellNibName: If non-nil, the cell will be dequeued using a nib with this name from the main bundle
     * parameter item: A closure that's called when a cell is about to be shown and needs to be configured.
     
     * returns: itself so you can daisy chain the other datasource calls
     */
    @discardableResult
    public func addFlowElements<Element,Cell>(
        _ elements: [Element],
        cell: Cell.Type,
        cellNibName: String? = nil,
        item: @escaping (_ element: Element, _ cell: inout Cell,_ index: Int) -> Void) -> Self
        where Cell: UICollectionViewCell {
            return _addSections([elements], cell: cell, cellNibName: cellNibName, item: item)
    }
    
    @discardableResult
    private func _addSections<Element,Cell>(
        _ elements: [[Element]],
        cell: Cell.Type,
        cellNibName: String? = nil,
        item: @escaping (_ element: Element, _ cell: inout Cell,_ index: Int) -> Void) -> Self
        where Cell: UICollectionViewCell {
            
            DelegateWrapper.remove(delegator: self, from: &CollectionViewDelegate.delegates)
            delegate = nil
            dataSource = nil
            let reuseIdentifier = "\(Element.self).\(cell)"
            
            if let nibName = cellNibName {
                register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            } else {
                register(Cell.self, forCellWithReuseIdentifier: reuseIdentifier)
            }
            
            return numberOfSectionsIn
                {
                    return elements.count
                }.numberOfItemsInSection {
                    return elements[$0].count
                }.cellForItemAt { [unowned self] in
                    let element = elements[$0.section][$0.item]
                    var cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: $0) as! Cell
                    item(element, &cell, $0.item)
                    return cell
            }
    }
}

class CollectionViewDelegate: ScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    fileprivate static var delegates = Set<DelegateWrapper<UICollectionView, CollectionViewDelegate>>()

    fileprivate var shouldHighlightItemAt: ((_ indexPath: IndexPath) -> Bool)?
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return shouldHighlightItemAt?(indexPath) ?? true
    }
    fileprivate var didHighlightItemAt: ((_ indexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        didHighlightItemAt?(indexPath)
    }
    fileprivate var didUnhighlightItemAt: ((_ indexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        didUnhighlightItemAt?(indexPath)
    }
    fileprivate var shouldSelectItemAt: ((_ indexPath: IndexPath) -> Bool)?
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return shouldSelectItemAt?(indexPath) ?? true
    }
    fileprivate var shouldDeselectItemAt: ((_ indexPath: IndexPath) -> Bool)?
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return shouldDeselectItemAt?(indexPath) ?? true
    }
    fileprivate var didSelectItemAt: ((_ indexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAt?(indexPath)
    }
    fileprivate var didDeselectItemAt: ((_ indexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didDeselectItemAt?(indexPath)
    }
    fileprivate var willDisplay: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay?(cell,indexPath)
    }
    fileprivate var willDisplaySupplementaryView: ((_ elementKind: String, _ indexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        willDisplaySupplementaryView?(elementKind,indexPath)
    }
    fileprivate var didEndDisplaying: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplaying?(cell,indexPath)
    }
    fileprivate var didEndDisplayingSupplementaryView: ((_ elementKind: String, _ indexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        didEndDisplayingSupplementaryView?(elementKind,indexPath)
    }
    fileprivate var shouldShowMenuForItemAt: ((_ indexPath: IndexPath) -> Bool)?
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return shouldShowMenuForItemAt?(indexPath) ?? false
    }
    fileprivate var canPerformAction: ((_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool)?
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return canPerformAction?(action, indexPath, sender) ?? false
    }
    fileprivate var performAction: ((_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Void)?
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        performAction?(action, indexPath, sender)
    }
    fileprivate var transitionLayoutForOldLayout: ((_ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)?
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        return transitionLayoutForOldLayout?(fromLayout,toLayout) ?? UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    fileprivate var canFocusItemAt: ((_ indexPath: IndexPath) -> Bool)?
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return canFocusItemAt?(indexPath) ?? false
    }
    fileprivate var shouldUpdateFocusIn: ((_ context: UICollectionViewFocusUpdateContext) -> Bool)?
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return shouldUpdateFocusIn?(context) ?? true
    }
    fileprivate var didUpdateFocusIn: ((_ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)?
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        didUpdateFocusIn?(context,coordinator)
    }
    fileprivate var indexPathForPreferredFocusedViewIn: (() -> IndexPath?)?
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return indexPathForPreferredFocusedViewIn?() ?? nil
    }
    fileprivate var targetIndexPathForMoveFromItemAt: ((_ originalIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath)?
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        return targetIndexPathForMoveFromItemAt?(originalIndexPath,proposedIndexPath) ?? proposedIndexPath
    }
    fileprivate var targetContentOffsetForProposedContentOffset: ((_ proposedContentOffset: CGPoint) -> CGPoint)?
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return targetContentOffsetForProposedContentOffset?(proposedContentOffset) ?? proposedContentOffset
    }
    private var _shouldSpringLoadItemAt: Any?
    @available(iOS 11, *)
    fileprivate var shouldSpringLoadItemAt: ((_ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool)? {
        get {
            return _shouldSpringLoadItemAt as? (_ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool
        }
        set {
            _shouldSpringLoadItemAt = newValue
        }
    }
    @available(iOS 11, *)
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return shouldSpringLoadItemAt?(indexPath, context) ?? true
    }
    fileprivate var numberOfItemsInSection: ((_ section: Int) -> Int)?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection?(section) ?? 0
    }
    fileprivate var cellForItemAt: ((_ indexPath: IndexPath) -> UICollectionViewCell)?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItemAt?(indexPath) ?? UICollectionViewCell()
    }
    fileprivate var numberOfSectionsIn: (() -> Int)?
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSectionsIn?() ?? 1
    }
    fileprivate var viewForSupplementaryElementOfKind: ((_ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView)?
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return viewForSupplementaryElementOfKind?(kind,indexPath) ?? UICollectionReusableView()
    }
    fileprivate var canMoveItemAt: ((_ indexPath: IndexPath) -> Bool)?
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return canMoveItemAt?(indexPath) ?? false
    }
    fileprivate var moveItemAt: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItemAt?(sourceIndexPath,destinationIndexPath)
    }
    fileprivate var indexTitlesFor: (() -> [String])?
    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return indexTitlesFor?() ?? []
    }
    fileprivate var indexPathForIndexTitle: ((_ title: String, _ index: Int) -> IndexPath)?
    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return indexPathForIndexTitle?(title,index) ?? IndexPath()
    }
    fileprivate var sizeForItemAt: ((_ indexPath: IndexPath) -> CGSize)?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItemAt?(indexPath) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? CGSize(width: 50, height: 50)
    }
    fileprivate var insetForSectionAt: ((_ section: Int) -> UIEdgeInsets)?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSectionAt?(section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
    }
    fileprivate var minimumLineSpacingForSectionAt: ((_ section: Int) -> CGFloat)?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSectionAt?(section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 10
    }
    fileprivate var minimumInteritemSpacingForSectionAt: ((_ section: Int) -> CGFloat)?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacingForSectionAt?(section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 10
    }
    fileprivate var referenceSizeForHeaderInSection: ((_ section: Int) -> CGSize)?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSizeForHeaderInSection?(section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize ?? .zero
    }
    fileprivate var referenceSizeForFooterInSection: ((_ section: Int) -> CGSize)?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSizeForFooterInSection?(section) ?? (collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize ?? .zero
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        if #available(iOS 11, *) {
            switch aSelector {
            case #selector(CollectionViewDelegate.collectionView(_:shouldSpringLoadItemAt:with:)):
                return _shouldSpringLoadItemAt != nil
            default:
                break
            }
        }
        
        switch aSelector {
        case #selector(CollectionViewDelegate.collectionView(_:shouldHighlightItemAt:)):
            return shouldHighlightItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:didHighlightItemAt:)):
            return didHighlightItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:didUnhighlightItemAt:)):
            return didUnhighlightItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:shouldSelectItemAt:)):
            return shouldSelectItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:shouldDeselectItemAt:)):
            return shouldDeselectItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:didSelectItemAt:)):
            return didSelectItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:didDeselectItemAt:)):
            return didDeselectItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:willDisplay:forItemAt:)):
            return willDisplay != nil
        case #selector(CollectionViewDelegate.collectionView(_:willDisplaySupplementaryView:forElementKind:at:)):
            return willDisplaySupplementaryView != nil
        case #selector(CollectionViewDelegate.collectionView(_:didEndDisplaying:forItemAt:)):
            return didEndDisplaying != nil
        case #selector(CollectionViewDelegate.collectionView(_:didEndDisplayingSupplementaryView:forElementOfKind:at:)):
            return didEndDisplayingSupplementaryView != nil
        case #selector(CollectionViewDelegate.collectionView(_:shouldShowMenuForItemAt:)):
            return shouldShowMenuForItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:canPerformAction:forItemAt:withSender:)):
            return canPerformAction != nil
        case #selector(CollectionViewDelegate.collectionView(_:performAction:forItemAt:withSender:)):
            return performAction != nil
        case #selector(CollectionViewDelegate.collectionView(_:transitionLayoutForOldLayout:newLayout:)):
            return transitionLayoutForOldLayout != nil
        case #selector(CollectionViewDelegate.collectionView(_:canFocusItemAt:)):
            return canFocusItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:shouldUpdateFocusIn:)):
            return shouldUpdateFocusIn != nil
        case #selector(CollectionViewDelegate.collectionView(_:didUpdateFocusIn:with:)):
            return didUpdateFocusIn != nil
        case #selector(CollectionViewDelegate.indexPathForPreferredFocusedView(in:)):
            return indexPathForPreferredFocusedViewIn != nil
        case #selector(CollectionViewDelegate.collectionView(_:targetIndexPathForMoveFromItemAt:toProposedIndexPath:)):
            return targetIndexPathForMoveFromItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:targetContentOffsetForProposedContentOffset:)):
            return targetContentOffsetForProposedContentOffset != nil
        case #selector(CollectionViewDelegate.collectionView(_:numberOfItemsInSection:)):
            return numberOfItemsInSection != nil
        case #selector(CollectionViewDelegate.collectionView(_:cellForItemAt:)):
            return cellForItemAt != nil
        case #selector(CollectionViewDelegate.numberOfSections(in:)):
            return numberOfSectionsIn != nil
        case #selector(CollectionViewDelegate.collectionView(_:viewForSupplementaryElementOfKind:at:)):
            return viewForSupplementaryElementOfKind != nil
        case #selector(CollectionViewDelegate.collectionView(_:canMoveItemAt:)):
            return canMoveItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:moveItemAt:to:)):
            return moveItemAt != nil
        case #selector(CollectionViewDelegate.indexTitles(for:)):
            return indexTitlesFor != nil
        case #selector(CollectionViewDelegate.collectionView(_:indexPathForIndexTitle:at:)):
            return indexPathForIndexTitle != nil
        case #selector(CollectionViewDelegate.collectionView(_:layout:sizeForItemAt:)):
            return sizeForItemAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:layout:insetForSectionAt:)):
            return insetForSectionAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:layout:minimumLineSpacingForSectionAt:)):
            return minimumLineSpacingForSectionAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:layout:minimumInteritemSpacingForSectionAt:)):
            return minimumInteritemSpacingForSectionAt != nil
        case #selector(CollectionViewDelegate.collectionView(_:layout:referenceSizeForHeaderInSection:)):
            return referenceSizeForHeaderInSection != nil
        case #selector(CollectionViewDelegate.collectionView(_:layout:referenceSizeForFooterInSection:)):
            return referenceSizeForFooterInSection != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

extension UICollectionView {
    // MARK: Delegate and DataSource Overrides
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:shouldHighlightItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldHighlightItemAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.shouldHighlightItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:didHighlightItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didHighlightItemAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didHighlightItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:didUnhighlightItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didUnhighlightItemAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didUnhighlightItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:shouldSelectItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldSelectItemAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.shouldSelectItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:shouldDeselectItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldDeselectItemAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.shouldDeselectItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:didSelectItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didSelectItemAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didSelectItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:didDeselectItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didDeselectItemAt(handler: @escaping (_ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didDeselectItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:willDisplay:forItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willDisplay(handler: @escaping (_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.willDisplay = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:willDisplaySupplementaryView:forElementKind:at:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willDisplaySupplementaryView(handler: @escaping (_ elementKind: String, _ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.willDisplaySupplementaryView = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:didEndDisplaying:forItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndDisplaying(handler: @escaping (_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didEndDisplaying = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:didEndDisplayingSupplementaryView:forElementOfKind:at:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndDisplayingSupplementaryView(handler: @escaping (_ elementKind: String, _ indexPath: IndexPath) -> Void) -> Self {
        return update { $0.didEndDisplayingSupplementaryView = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:shouldShowMenuForItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldShowMenuForItemAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.shouldShowMenuForItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:canPerformAction:forItemAt:withSender:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func canPerformAction(handler: @escaping (_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        return update { $0.canPerformAction = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:performAction:forItemAt:withSender:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func performAction(handler: @escaping (_ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Void) -> Self {
        return update { $0.performAction = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:transitionLayoutForOldLayout:newLayout:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func transitionLayoutForOldLayout(handler: @escaping (_ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout) -> Self {
        return update { $0.transitionLayoutForOldLayout = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:canFocusItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func canFocusItemAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.canFocusItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:shouldUpdateFocusIn:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldUpdateFocusIn(handler: @escaping (_ context: UICollectionViewFocusUpdateContext) -> Bool) -> Self {
        return update { $0.shouldUpdateFocusIn = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:didUpdateFocusIn:with:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didUpdateFocusIn(handler: @escaping (_ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void) -> Self {
        return update { $0.didUpdateFocusIn = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's indexPathForPreferredFocusedVies(in:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func indexPathForPreferredFocusedViewIn(handler: @escaping () -> IndexPath?) -> Self {
        return update { $0.indexPathForPreferredFocusedViewIn = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:targetIndexPathForMoveFromItemAt:toProposedIndexPath:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func targetIndexPathForMoveFromItemAt(handler: @escaping (_ originalIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath) -> Self {
        return update { $0.targetIndexPathForMoveFromItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:targetContentOffsetForProposedContentOffset:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func targetContentOffsetForProposedContentOffset(handler: @escaping (_ proposedContentOffset: CGPoint) -> CGPoint) -> Self {
        return update { $0.targetContentOffsetForProposedContentOffset = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegate's collectionView(_:shouldSpringLoadItemAt:with:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @available(iOS 11, *) @discardableResult
    public func shouldSpringLoadItemAt(handler: @escaping (_ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) -> Self {
        return update { $0.shouldSpringLoadItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDataSource's collectionView(_:numberOfItemsInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func numberOfItemsInSection(handler: @escaping (_ section: Int) -> Int) -> Self {
        return update { $0.numberOfItemsInSection = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDataSource's collectionView(_:cellForItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func cellForItemAt(handler: @escaping (_ indexPath: IndexPath) -> UICollectionViewCell) -> Self {
        return update { $0.cellForItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDataSource's numberOfSections(in:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func numberOfSectionsIn(handler: @escaping () -> Int) -> Self {
        return update { $0.numberOfSectionsIn = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDataSource's collectionView(_:viewForSupplementaryElementOfKind:at:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func viewForSupplementaryElementOfKind(handler: @escaping (_ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView) -> Self {
        return update { $0.viewForSupplementaryElementOfKind = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDataSource's collectionView(_:canMoveItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func canMoveItemAt(handler: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        return update { $0.canMoveItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDataSource's collectionView(_:moveItemAt:to:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func moveItemAt(handler: @escaping (_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void) -> Self {
        return update { $0.moveItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDataSource's indexTitles(for:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func indexTitlesFor(handler: @escaping () -> [String]) -> Self {
        return update { $0.indexTitlesFor = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDataSource's collectionView(_:indexPathForIndexTitle:at:) method
     
     * parameter handler: The closure that will be called in place of its equivalent dataSource method
     
     * returns: itself so you can daisy chain the other dataSource calls
     */
    @discardableResult
    public func indexPathForIndexTitle(handler: @escaping (_ title: String, _ index: Int) -> IndexPath) -> Self {
        return update { $0.indexPathForIndexTitle = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegateFlowLayout's collectionView(_:layout:sizeForItemAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func sizeForItemAt(handler: @escaping (_ indexPath: IndexPath) -> CGSize) -> Self {
        return update { $0.sizeForItemAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegateFlowLayout's collectionV(_:layout:insetForSectionAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func insetForSectionAt(handler: @escaping (_ section: Int) -> UIEdgeInsets) -> Self {
        return update { $0.insetForSectionAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegateFlowLayout's collectionView(_:layout:minimumLineSpacingForSectionAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func minimumLineSpacingForSectionAt(handler: @escaping (_ section: Int) -> CGFloat) -> Self {
        return update { $0.minimumLineSpacingForSectionAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegateFlowLayout's collectionView(_:layout:minimumInteritemSpacingForSectionAt:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func minimumInteritemSpacingForSectionAt(handler: @escaping (_ section: Int) -> CGFloat) -> Self {
        return update { $0.minimumInteritemSpacingForSectionAt = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegateFlowLayout's collectionView(_:layout:referenceSizeForHeaderInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func referenceSizeForHeaderInSection(handler: @escaping (_ section: Int) -> CGSize) -> Self {
        return update { $0.referenceSizeForHeaderInSection = handler }
    }
    /**
     Equivalent to implementing UICollectionViewDelegateFlowLayout's collectionView(_:layout:referenceSizeForFooterInSection:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func referenceSizeForFooterInSection(handler: @escaping (_ section: Int) -> CGSize) -> Self {
        return update { $0.referenceSizeForFooterInSection = handler }
    }
}

extension UICollectionView {
    @discardableResult
    @objc override func update(handler: (_ delegate: CollectionViewDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: CollectionViewDelegate(),
                               delegates: &CollectionViewDelegate.delegates,
                               bind: UICollectionView.bind) {
            handler($0.delegate)
        }
        return self
    }
    
    // MARK: Reset
    /**
     Clears any delegate/dataSource closures that were assigned to this
     `UICollectionView`. This cleans up memory as well as sets the
     delegate/dataSource properties to nil. This is typically only used for explicit
     cleanup. You are not required to call this method.
     */
    @objc override public func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &CollectionViewDelegate.delegates)
        UICollectionView.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: UICollectionView, _ delegate: CollectionViewDelegate?) {
        delegator.delegate = nil
        delegator.dataSource = nil
        delegator.delegate = delegate
        delegator.dataSource = delegate
    }
}
