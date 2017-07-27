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

import XCTest
@testable import Closures

class UIGestureRecognizerTests: XCTestCase {
    func testDelegateCalls() {
        let gesture = UIGestureRecognizer()
        let exp = expectation(description: "Not all methods called")
        exp.expectedFulfillmentCount = 6
        let increaseFulfillment: ()->Bool = {
            exp.fulfill()
            return true
        }
        gesture
            .shouldBegin(handler: increaseFulfillment)
            .shouldRecognizeSimultaneouslyWith(handler: {_ in increaseFulfillment()})
            .shouldRequireFailureOf(handler: {_ in increaseFulfillment()})
            .shouldBeRequiredToFailBy(handler: {_ in increaseFulfillment()})
            .shouldReceiveTouch(handler: {_ in increaseFulfillment()})
            .shouldReceivePress(handler: {_ in increaseFulfillment()})
        
        _ = gesture.delegate!.gestureRecognizerShouldBegin!(gesture)
        _ = gesture.delegate!.gestureRecognizer!(gesture, shouldRecognizeSimultaneouslyWith: gesture)
        _ = gesture.delegate!.gestureRecognizer!(gesture, shouldRequireFailureOf: gesture)
        _ = gesture.delegate!.gestureRecognizer!(gesture, shouldBeRequiredToFailBy: gesture)
        _ = gesture.delegate!.gestureRecognizer!(gesture, shouldReceive: UITouch())
        _ = gesture.delegate!.gestureRecognizer!(gesture, shouldReceive: UIPress())
        
        waitForExpectations(timeout: 0.2)
    }
    
    func testTargetActionCycle() {
        let exp = expectation(description: "Action handler never fired")
        let gesture = CustomGesture(exp.fulfill())
        gesture.trigger()
        waitForExpectations(timeout: 0.2)
    }
}

import UIKit.UIGestureRecognizerSubclass
public class CustomGesture: UIGestureRecognizer {
    convenience init(_ handler: @autoclosure @escaping ()->Void) {
        self.init()
        Closures.configure(gesture: self) { _ in
            handler()
        }
    }
    
    func trigger() {
        let sel = NSSelectorFromString("gestureRecognized")
        perform(sel)
    }
}
