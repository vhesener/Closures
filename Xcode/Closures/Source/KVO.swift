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

import Foundation

extension NSObject {
    public var selfDeinits: (_KeyValueCodingAndObserving) -> Bool {
        return { [weak self] _ in
            return self == nil
        }
    }
}

extension _KeyValueCodingAndObserving {
    /**
     This convenience method puts only a tiny bit of polish on
     Swift's latest closure-based KVO implementation. Although
     there aren't many obvious differences between this
     method and the one in `Foundation`, there are a few helpers, which
     are describe below.
     
     First, it passes a remove condition, `until`, which is simpy a closure
     that gets called to determine whether to remove the observation
     closure. Returning true will remove the observer, otherwise, the
     observing will continue. `Foundation`'s method
     automatically removes observation when the `NSKeyValueObservation`
     is released, but this requires you to save it somewhere in your
     view controller as a property, thereby cluttering up your view
     controller with plumbing-only members.
     
     Second, this method attempts to slightly improve the clutter. You
     do not have to save the observer. `@discardableResult` allows you
     to disregard the returned object entirely.
     
     Finally, a typical pattern is to remove observers when deinit is
     called on the object that owns the observed object.
     For instance, if you are observing a model object property on your
     view controller, you will probably want to stop observing when the
     view controller gets released from memory. Because this is a
     common pattern, there's a convenient var available on all subclasses
     of NSObject named `selfDeinits`. Simply pass this as a parameter
     into the `until` paramaeter, and the observation will be removed
     when `self` is deallocated.
     
     * * * *
     #### An example of calling this method:
     ```swift
     <#someObject#>.observe(\.<#some.key.path#>, until: selfDeinits) { obj,change in
         <#do something#>
     }
     ```
     
     * parameter keyPath: The keyPath you wish to observe on this object
     * parameter options: The observing options
     * parameter until: The closure called when this handler should stop
     observing. Return true if you want to forcefully stop observing.
     * parameter changeHandler: The callback that will be called when
     the keyPath change has occurred.
     
     * returns: The observer object needed to remove observation
     */
    @discardableResult
    public func observe<Value>(
        _ keyPath: KeyPath<Self, Value>,
        options: NSKeyValueObservingOptions = [],
        until removeCondition: @escaping (Self) -> Bool,
        changeHandler: @escaping (Self, NSKeyValueObservedChange<Value>) -> Void)
        -> NSKeyValueObservation {
            var observer: NSKeyValueObservation?
            observer = self.observe(keyPath, options: options) { obj, change in
                guard !removeCondition(obj) else {
                    observer?.invalidate()
                    observer = nil
                    return
                }
                changeHandler(obj, change)
            }
            return observer!
    }
}
