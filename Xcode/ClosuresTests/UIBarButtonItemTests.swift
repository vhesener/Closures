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

class UIBarButtonItemTests: XCTestCase {
    func testTargetActionInitializers() {
        let exp = expectation(description: "Not all initializers handled")
        exp.expectedFulfillmentCount = 4
        let handler = { exp.fulfill() }
        let buttons = [
            UIBarButtonItem(image: nil, style: .plain, handler: handler),
            UIBarButtonItem(image: nil, landscapeImagePhone: nil, style: .plain, handler: handler),
            UIBarButtonItem(title: nil, style: .plain, handler: handler),
            UIBarButtonItem(barButtonSystemItem: .action, handler: handler)]
        
        buttons.forEach {
            _ = $0.target!.perform($0.action)
        }
        waitForExpectations(timeout: 0.2)
    }
    
    func testCleanup() {
        let button = UIBarButtonItem(barButtonSystemItem: .action) {
            XCTAssert(false, "Closures are being added, not replaced")
        }
        button.onTap {
        }
        NotificationCenter.closures.post(name: Notification.Name("UIBarButtonItem.tapped"), object: button)
    }
}
