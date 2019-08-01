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
class ScrollViewDelegate: NSObject, UIScrollViewDelegate, DelegateProtocol {
    fileprivate static var delegates = Set<DelegateWrapper<UIScrollView, ScrollViewDelegate>>()
    
    fileprivate var didScroll: ((_ scrollView: UIScrollView) -> Void)?
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    
    fileprivate var didZoom: ((_ scrollView: UIScrollView) -> Void)?
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        didZoom?(scrollView)
    }
    
    fileprivate var willBeginDragging: ((_ scrollView: UIScrollView) -> Void)?
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging?(scrollView)
    }
    
    fileprivate var willEndDragging: ((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        willEndDragging?(scrollView, velocity, targetContentOffset)
    }
    
    fileprivate var didEndDragging: ((_ scrollView: UIScrollView, _ decelerate: Bool) -> Void)?
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging?(scrollView, decelerate)
    }
    
    fileprivate var willBeginDecelerating: ((_ scrollView: UIScrollView) -> Void)?
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        willBeginDecelerating?(scrollView)
    }
    
    fileprivate var didEndDecelerating: ((_ scrollView: UIScrollView) -> Void)?
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating?(scrollView)
    }
    
    fileprivate var didEndScrollingAnimation: ((_ scrollView: UIScrollView) -> Void)?
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation?(scrollView)
    }
    
    fileprivate var viewForZoomingIn: ((_ scrollView: UIScrollView) -> UIView?)?
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZoomingIn?(scrollView)
    }
    
    fileprivate var willBeginZooming: ((_ scrollView: UIScrollView, _ view: UIView?) -> Void)?
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        willBeginZooming?(scrollView, view)
    }
    
    fileprivate var didEndZooming: ((_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat) -> Void)?
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        didEndZooming?(scrollView, view, scale)
    }
    
    fileprivate var shouldScrollToTop: ((_ scrollView: UIScrollView) -> Bool)?
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return shouldScrollToTop?(scrollView) ?? true
    }
    
    fileprivate var didScrollToTop: ((_ scrollView: UIScrollView) -> Void)?
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        didScrollToTop?(scrollView)
    }
    
    fileprivate var didChangeAdjustedContentInset: ((_ scrollView: UIScrollView) -> Void)?
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        didChangeAdjustedContentInset?(scrollView)
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(ScrollViewDelegate.scrollViewDidScroll(_:)):
            return didScroll != nil
        case #selector(ScrollViewDelegate.scrollViewDidZoom(_:)):
            return didZoom != nil
        case #selector(ScrollViewDelegate.scrollViewWillBeginDragging(_:)):
            return willBeginDragging != nil
        case #selector(ScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)):
            return willEndDragging != nil
        case #selector(ScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)):
            return didEndDragging != nil
        case #selector(ScrollViewDelegate.scrollViewWillBeginDecelerating(_:)):
            return willBeginDecelerating != nil
        case #selector(ScrollViewDelegate.scrollViewDidEndDecelerating(_:)):
            return didEndDecelerating != nil
        case #selector(ScrollViewDelegate.scrollViewDidEndScrollingAnimation(_:)):
            return didEndScrollingAnimation != nil
        case #selector(ScrollViewDelegate.viewForZooming(in:)):
            return viewForZoomingIn != nil
        case #selector(ScrollViewDelegate.scrollViewWillBeginZooming(_:with:)):
            return willBeginZooming != nil
        case #selector(ScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:)):
            return didEndZooming != nil
        case #selector(ScrollViewDelegate.scrollViewShouldScrollToTop(_:)):
            return shouldScrollToTop != nil
        case #selector(ScrollViewDelegate.scrollViewDidScrollToTop(_:)):
            return didScrollToTop != nil
        case #selector(ScrollViewDelegate.scrollViewDidChangeAdjustedContentInset(_:)):
            return didChangeAdjustedContentInset != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

@available(iOS 9.0, *)
extension UIScrollView {
    // MARK: Delegate Overrides
    /**
     Equivalent to implementing UIScrollView's scrollViewDidScroll(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didScroll(handler: @escaping (_ scrollView: UIScrollView) -> Void) -> Self {
        return update { $0.didScroll = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewDidZoom(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didZoom(handler: @escaping (_ scrollView: UIScrollView) -> Void) -> Self {
        return update { $0.didZoom = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewWillBeginDragging(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willBeginDragging(handler: @escaping (_ scrollView: UIScrollView) -> Void) -> Self {
        return update { $0.willBeginDragging = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewWillEndDragging(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willEndDragging(handler: @escaping (_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void) -> Self {
        return update { $0.willEndDragging = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewDidEndDragging(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndDragging(handler: @escaping (_ scrollView: UIScrollView, _ decelerate: Bool) -> Void) -> Self {
        return update { $0.didEndDragging = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewWillBeginDecelerating(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willBeginDecelerating(handler: @escaping (_ scrollView: UIScrollView) -> Void) -> Self {
        return update { $0.willBeginDecelerating = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewDidEndDecelerating(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndDecelerating(handler: @escaping (_ scrollView: UIScrollView) -> Void) -> Self {
        return update { $0.didEndDecelerating = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewDidEndScrollingAnimation(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndScrollingAnimation(handler: @escaping (_ scrollView: UIScrollView) -> Void) -> Self {
        return update { $0.didEndScrollingAnimation = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's viewForZooming(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func viewForZoomingIn(handler: @escaping (_ scrollView: UIScrollView) -> UIView?) -> Self {
        return update { $0.viewForZoomingIn = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewWillBeginZooming(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func willBeginZooming(handler: @escaping (_ scrollView: UIScrollView, _ view: UIView?) -> Void) -> Self {
        return update { $0.willBeginZooming = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewDidEndZooming(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didEndZooming(handler: @escaping (_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat) -> Void) -> Self {
        return update { $0.didEndZooming = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewShouldScrollToTop(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func shouldScrollToTop(handler: @escaping (_ scrollView: UIScrollView) -> Bool) -> Self {
        return update { $0.shouldScrollToTop = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewDidScrollToTop(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didScrollToTop(handler: @escaping (_ scrollView: UIScrollView) -> Void) -> Self {
        return update { $0.didScrollToTop = handler }
    }
    
    /**
     Equivalent to implementing UIScrollView's scrollViewDidChangeAdjustedContentInset(_:) method
     
     * parameter handler: The closure that will be called in place of its equivalent delegate method
     
     * returns: itself so you can daisy chain the other delegate calls
     */
    @discardableResult
    public func didChangeAdjustedContentInset(handler: @escaping (_ scrollView: UIScrollView) -> Void) -> Self {
        return update { $0.didChangeAdjustedContentInset = handler }
    }
}

@available(iOS 9.0, *)
extension UIScrollView: DelegatorProtocol {
    @discardableResult
    @objc func update(handler: (_ delegate: ScrollViewDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: ScrollViewDelegate(),
                               delegates: &ScrollViewDelegate.delegates,
                               bind: UIScrollView.bind) {
                                handler($0.delegate)
        }
        return self
    }
    
    // MARK: Reset
    /**
     Clears any delegate closures that were assigned to this
     `UIScrollView`. This cleans up memory as well as sets the
     delegate property to nil. This is typically only used for explicit
     cleanup. You are not required to call this method.
     */
    @objc public func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &ScrollViewDelegate.delegates)
        UIScrollView.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: UIScrollView, _ delegate: ScrollViewDelegate?) {
        delegator.delegate = nil
        delegator.delegate = delegate
    }
}
