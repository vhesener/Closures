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

protocol DelegateProtocol: class {
}

public protocol DelegatorProtocol: class {
    /**
     Clears any delegates/datasources that were assigned by the `Closures`
     framework for this object. This cleans up memory as well as sets the
     delegate/datasource properties to nil.
     */
    func clearClosureDelegates()
}

class DelegateWrapper<Delegator: DelegatorProtocol, Delegate: DelegateProtocol>: NSObject {
    weak var delegator: Delegator?
    let delegate: Delegate
    
    init(delegator: Delegator, delegate: Delegate) {
        self.delegate = delegate
        self.delegator = delegator
    }
    
    var tupac: Bool { return delegator == nil }
    
    public static func wrapper(delegator: Delegator,
                               delegate: @autoclosure () -> Delegate,
                               delegates:  inout Set<DelegateWrapper<Delegator,Delegate>>,
                               bind: (_ delegator: Delegator, _ delegate: Delegate) -> Void) -> DelegateWrapper<Delegator,Delegate> {
        var deadRappers = [DelegateWrapper<Delegator,Delegate>]()
        defer {
            delegates.subtract(deadRappers)
        }
        
        if let wrapper = delegates.first(where: {
            // lazy, inaccurate cleanup.
            if $0.tupac {
                deadRappers.append($0)
            }
            return $0.delegator === delegator
        }) {
            return wrapper
        }
        let delegate = delegate()
        let wrapper: DelegateWrapper<Delegator,Delegate> = DelegateWrapper(delegator: delegator, delegate: delegate)
        bind(delegator, delegate)
        delegates.insert(wrapper)
        
        return wrapper
    }
    
    public static func remove(delegator: Delegator, from delegates: inout Set<DelegateWrapper<Delegator,Delegate>>) {
        if let wrapper = delegates.first(where: { $0.delegator === delegator }) {
            delegates.remove(wrapper)
        }
    }
    
    public static func update(_ delegator: Delegator,
                              delegate: @autoclosure () -> Delegate,
                              delegates:  inout Set<DelegateWrapper<Delegator,Delegate>>,
                              bind: (_ delegator: Delegator, _ delegate: Delegate) -> Void,
                              with updateHandler: (_ wrapper: DelegateWrapper<Delegator, Delegate>) -> Void)  {
        let wrapper = self.wrapper(delegator: delegator, delegate: delegate, delegates: &delegates, bind: bind)
        updateHandler(wrapper)
        bind(delegator, wrapper.delegate)
    }
}

fileprivate class BundleHook {}
extension Bundle {
    static let closures = Bundle(for: BundleHook.self)
}

extension String {
    static let namespace = Bundle.closures.bundleIdentifier ?? ""
}

extension NotificationCenter {
    static func selfObserve<T>(name: Notification.Name,
                               target: T,
                               closure: @escaping (_ target: T, _ userInfo: [AnyHashable : Any]?) -> Void) where T: AnyObject {
        NotificationCenter.closures.selfObserve(name: name, target: target, closure: closure)
    }
    
    func selfObserve<T>(name: Notification.Name,
                        target: T,
                        closure: @escaping (_ target: T, _ userInfo: [AnyHashable : Any]?) -> Void) where T: AnyObject {
        
        // Post a cleanup notification to remove any duplicates
        let cleanupKey = "com.vhesener.notificationkey.selfobserved.cleanup"
        post(name: name, object: target, userInfo: [cleanupKey: target])
        
        var observer: NSObjectProtocol?
        observer = addObserver(
            forName: name,
            // Can't use the object for this parameter. Since the object
            // is the one sending the post, it will never clean up. The observer
            // will always stay in the notification center and I'm not sure of
            // the concequences of that yet.
            object: nil,
            queue: nil) { [weak target, weak self] in
                // Cleanup any notification with this name;target combo
                if let cleanupTarget = $0.userInfo?[cleanupKey] as? T {
                    if cleanupTarget === target,
                        $0.name == name {
                        self?.removeObserver(observer!)
                    }
                    return
                }
                // Remove if target is nil (target-action on self is fruitless)
                guard let target = target else {
                    self?.removeObserver(observer!)
                    observer = nil
                    return
                }
                // Defensive check that self is posting and the target
                guard let object = $0.object as? T,
                    object === target else {
                        return
                }
                closure(target, $0.userInfo)
        }
    }
    
    @discardableResult
    static func observeUntil<T>(
        _ removeCondition: @escaping (_ object: T?) -> Bool,
        object: T,
        name: Notification.Name,
        closure: @escaping (_ object: T, _ userInfo: [AnyHashable : Any]?) -> Void) -> NSObjectProtocol where T: AnyObject {
        return NotificationCenter.closures.observeUntil(removeCondition, object: object, name: name, closure: closure)
    }
    
    @discardableResult
    func observeUntil<T>(
        _ removeCondition: @escaping (_ object: T?) -> Bool,
        object: T,
        name: Notification.Name,
        closure: @escaping (_ object: T, _ userInfo: [AnyHashable : Any]?) -> Void) -> NSObjectProtocol where T: AnyObject {
        var observer: NSObjectProtocol?
        observer = addObserver(
            forName: name,
            object: object,
            queue: nil) { [weak object, weak self] in
                // Explicit cleanup condition for this observer.
                guard !removeCondition(object),
                    let object = object else {
                        self?.removeObserver(observer!)
                        observer = nil
                        return
                }
                closure(object, $0.userInfo)
        }
        return observer!
    }
}

extension NotificationCenter {
    static let closures = NotificationCenter()
}
