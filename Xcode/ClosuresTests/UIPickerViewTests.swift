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

class UIPickerViewTests: XCTestCase {
    func testDelegateCalls() {
        let picker = UIPickerView()
        let exp = expectation(description: "Not all methods called")
        exp.expectedFulfillmentCount = 8
        picker
            .rowHeightForComponent() { _ in exp.fulfill(); return 0 }
            .widthForComponent() { _ in exp.fulfill(); return 0 }
            .titleForRow() { _,_ in exp.fulfill(); return "" }
            .attributedTitleForRow() { _,_ in exp.fulfill(); return nil }
            .viewForRow() { _,_,_ in exp.fulfill(); return UIView() }
            .didSelectRow() { _,_ in exp.fulfill() }
            .numberOfComponents() { exp.fulfill(); return 0 }
            .numberOfRowsInComponent() { _ in exp.fulfill(); return 0 }
        
        _ = picker.delegate!.pickerView!(picker, rowHeightForComponent: 0)
        _ = picker.delegate!.pickerView!(picker, widthForComponent: 0)
        _ = picker.delegate!.pickerView!(picker, titleForRow: 0, forComponent: 0)
        _ = picker.delegate!.pickerView!(picker, attributedTitleForRow: 0, forComponent: 0)
        _ = picker.delegate!.pickerView!(picker, viewForRow: 0, forComponent: 0, reusing: UIView())
        _ = picker.delegate?.pickerView!(picker, didSelectRow: 0, inComponent: 0)
        _ = picker.dataSource?.numberOfComponents(in: picker)
        _ = picker.dataSource?.pickerView(picker, numberOfRowsInComponent: 0)
        
        waitForExpectations(timeout: 0.2)
    }
}
