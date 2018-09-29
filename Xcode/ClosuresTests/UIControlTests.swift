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

class UIControlTests: XCTestCase {
    let button1 = UIButton(type: .custom)
    let button2 = UIButton(type: .custom)
    let textField = UITextField()
    let stepper = UIStepper()
    
    override func setUp() {
        super.setUp()
    }
    
    func testButtons() {
        var tap1Fired = false
        var tap2Fired = false
        button1.onTap {
            tap1Fired = true
        }
        button2.onTap {
            tap2Fired = true
        }
        button1.touchUpInside(sender: button1, event: nil)
        XCTAssert(tap1Fired)
        XCTAssertFalse(tap2Fired)
    }
    
    func testCleanup() {
        let description = NotificationCenter.closures.debugDescription
        var button3: UIButton? = UIButton(type: .custom)
        button3?.onTap {
            
        }
        XCTAssertNotEqual(description, NotificationCenter.closures.debugDescription)
        button3?.touchUpInside(sender: button3!, event: nil)
        button3 = nil
        button1.touchUpInside(sender: button1, event: nil)
        XCTAssertEqual(description, NotificationCenter.closures.debugDescription)
    }
    
    func testTextFields() {
        textField.text = "old text"
        let newText = "new text"
        var textChangeFired = false
        textField.onChange { text in
            textChangeFired = true
            XCTAssertEqual(text, newText)
            XCTAssertEqual(self.textField.text, newText)
        }
        textField.text = newText
        textField.editingChanged(sender: textField, event: nil)
        XCTAssert(textChangeFired)
    }
    
    func testValueChanges() {
        stepper.value = 0.0
        let newValue = 1.0
        var stepperFired = false
        stepper.onChange { value in
            stepperFired = true
            XCTAssertEqual(value, newValue)
            XCTAssertEqual(self.stepper.value, newValue)
        }
        stepper.value = newValue
        stepper.valueChanged(sender: stepper, event: nil)
        XCTAssert(stepperFired)
    }
    
    func testTextFieldDelegation() {
        let textField = UITextField()
        let exp = expectation(description: "Not all methods called")
        exp.expectedFulfillmentCount = 7
        textField.shouldBeginEditing {exp.fulfill(); return true}
            .didBeginEditing {exp.fulfill()}
            .shouldEndEditing {exp.fulfill(); return true}
            .didEndEditing {exp.fulfill()}
            .shouldChangeCharacters { (_, _) -> Bool in exp.fulfill(); return true;}
            .shouldChangeString {
                exp.fulfill()
                XCTAssertEqual($0, "old text")
                XCTAssertEqual($1, "new text")
                return true
            }
            .shouldClear {exp.fulfill(); return true}
            .shouldReturn {exp.fulfill(); return true}
        
        let delegate = textField.delegate
        XCTAssertNotNil(delegate)
        
        _ = delegate?.textFieldShouldBeginEditing!(textField)
        delegate?.textFieldDidBeginEditing!(textField)
        _ = delegate?.textFieldShouldEndEditing!(textField)
        delegate?.textFieldDidEndEditing!(textField)
        textField.text = "old text"
        _ = delegate?.textField!(textField, shouldChangeCharactersIn: NSMakeRange(0, 3), replacementString: "new")
        _ = delegate?.textFieldShouldClear!(textField)
        _ = delegate?.textFieldShouldReturn!(textField)
        
        waitForExpectations(timeout: 0.2)
    }
}
