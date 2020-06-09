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
import ObjectiveC

class UITableViewTests: XCTestCase {
    class CustomUpdateContext: UITableViewFocusUpdateContext { init(blah: Int){}}
    func testTableViewDelegation() {
        let tableView = UITableView()
        let exp = expectation(description: "Not all methods called")
        exp.expectedFulfillmentCount = 46
        tableView.willDisplay { _,_ in
            exp.fulfill()
        }
        tableView.willDisplayHeaderView { _,_ in
            exp.fulfill()
        }
        tableView.willDisplayFooterView { _,_ in
            exp.fulfill()
        }
        tableView.didEndDisplaying { _,_ in
            exp.fulfill()
        }
        tableView.didEndDisplayingHeaderView { _,_ in
            exp.fulfill()
        }
        tableView.didEndDisplayingFooterView { _,_ in
            exp.fulfill()
        }
        tableView.heightForRowAt { _ in
            exp.fulfill()
            return 0
        }
        tableView.heightForHeaderInSection { _ in
            exp.fulfill()
            return 0
        }
        tableView.heightForFooterInSection { _ in
            exp.fulfill()
            return 0
        }
        tableView.estimatedHeightForRowAt { _ in
            exp.fulfill()
            return 0
        }
        tableView.estimatedHeightForHeaderInSection { _ in
            exp.fulfill()
            return 0
        }
        tableView.estimatedHeightForFooterInSection { _ in
            exp.fulfill()
            return 0
        }
        tableView.viewForHeaderInSection { _ in
            exp.fulfill()
            return nil
        }
        tableView.viewForFooterInSection { _ in
            exp.fulfill()
            return nil
        }
        tableView.accessoryButtonTappedForRowWith { _ in
            exp.fulfill()
        }
        tableView.shouldHighlightRowAt { _ in
            exp.fulfill()
            return true
        }
        tableView.didHighlightRowAt { _ in
            exp.fulfill()
        }
        tableView.didUnhighlightRowAt { _ in
            exp.fulfill()
        }
        tableView.willSelectRowAt { _ in
            exp.fulfill()
            return nil
        }
        tableView.willDeselectRowAt { _ in
            exp.fulfill()
            return nil
        }
        tableView.didSelectRowAt { _ in
            exp.fulfill()
        }
        tableView.didDeselectRowAt { _ in
            exp.fulfill()
        }
        tableView.editingStyleForRowAt { _ in
            exp.fulfill()
            return .delete
        }
        tableView.titleForDeleteConfirmationButtonForRowAt { _ in
            exp.fulfill()
            return nil
        }
        if #available(iOS 13, *) {
            exp.expectedFulfillmentCount -= 1
        } else {
            tableView.editActionsForRowAt { _ in
                exp.fulfill()
                return nil
            }
        }
        tableView.shouldIndentWhileEditingRowAt { _ in
            exp.fulfill()
            return true
        }
        tableView.willBeginEditingRowAt { _ in
            exp.fulfill()
        }
        tableView.didEndEditingRowAt { _ in
            exp.fulfill()
        }
        tableView.targetIndexPathForMoveFromRowAt {
            exp.fulfill()
            return $1
        }
        tableView.indentationLevelForRowAt { _ in
            exp.fulfill()
            return 0
        }
        if #available(iOS 13, *) {
            exp.expectedFulfillmentCount -= 3
        } else {
            tableView.shouldShowMenuForRowAt { _ in
                exp.fulfill()
                return true
            }
            tableView.canPerformAction {_,_,_ in
                exp.fulfill()
                return true
            }
            tableView.performAction { _,_,_ in
                exp.fulfill()
            }
        }
        tableView.canFocusRowAt { _ in
            exp.fulfill()
            return true
        }
        tableView.indexPathForPreferredFocusedView {
            exp.fulfill()
            return nil
        }
        tableView.numberOfRows { _ in
            exp.fulfill()
            return 0
        }
        tableView.cellForRow { _ in
            exp.fulfill()
            return UITableViewCell()
        }
        tableView.numberOfSectionsIn {
            exp.fulfill()
            return 0
        }
        tableView.titleForHeaderInSection { _ in
            exp.fulfill()
            return nil
        }
        tableView.titleForFooterInSection { _ in
            exp.fulfill()
            return nil
        }
        tableView.canEditRowAt { _ in
            exp.fulfill()
            return true
        }
        tableView.canMoveRowAt { _ in
            exp.fulfill()
            return true
        }
        tableView.sectionIndexTitles {
            exp.fulfill()
            return nil
        }
        tableView.sectionForSectionIndexTitle { _,_ in
            exp.fulfill()
            return 0
        }
        tableView.commit { _,_ in
            exp.fulfill()
        }
        tableView.moveRowAt { _,_ in
            exp.fulfill()
        }
        if #available(iOS 13, *) {
            exp.expectedFulfillmentCount += 3
            tableView.shouldBeginMultipleSelectionInteraction { (_) -> Bool in
                exp.fulfill()
                return false
            }
            tableView.didBeginMultipleSelectionInteractionAt { (_) in
                exp.fulfill()
            }
            tableView.didEndMultipleSelectionInteraction {
                exp.fulfill()
            }
        }
        
        XCTAssertNotNil(tableView.delegate)
        XCTAssertNotNil(tableView.dataSource)
        
        let delegate = tableView.delegate!
        let datasource = tableView.dataSource!
        let iPath = IndexPath()

        delegate.tableView!(tableView, willDisplay: UITableViewCell(), forRowAt: iPath)
        delegate.tableView!(tableView, willDisplayHeaderView: UITableViewCell(), forSection: 0)
        delegate.tableView!(tableView, willDisplayFooterView: UITableViewCell(), forSection: 0)
        delegate.tableView!(tableView, didEndDisplaying: UITableViewCell(), forRowAt: iPath)
        delegate.tableView!(tableView, didEndDisplayingHeaderView: UITableViewCell(), forSection: 0)
        delegate.tableView!(tableView, didEndDisplayingFooterView: UITableViewCell(), forSection: 0)
        _ = delegate.tableView!(tableView, heightForRowAt: iPath)
        _ = delegate.tableView!(tableView, heightForHeaderInSection: 0)
        _ = delegate.tableView!(tableView, heightForFooterInSection: 0)
        _ = delegate.tableView!(tableView, estimatedHeightForRowAt: iPath)
        _ = delegate.tableView!(tableView, estimatedHeightForHeaderInSection: 0)
        _ = delegate.tableView!(tableView, estimatedHeightForFooterInSection: 0)
        _ = delegate.tableView!(tableView, viewForHeaderInSection: 0)
        _ = delegate.tableView!(tableView, viewForFooterInSection: 0)
        delegate.tableView!(tableView, accessoryButtonTappedForRowWith: iPath)
        _ = delegate.tableView!(tableView, shouldHighlightRowAt: iPath)
        delegate.tableView!(tableView, didHighlightRowAt: iPath)
        delegate.tableView!(tableView, didUnhighlightRowAt: iPath)
        _ = delegate.tableView!(tableView, willSelectRowAt: iPath)
        _ = delegate.tableView!(tableView, willDeselectRowAt: iPath)
        delegate.tableView!(tableView, didSelectRowAt: iPath)
        delegate.tableView!(tableView, didDeselectRowAt: iPath)
        _ = delegate.tableView!(tableView, editingStyleForRowAt: iPath)
        _ = delegate.tableView!(tableView, titleForDeleteConfirmationButtonForRowAt: iPath)
        if #available(iOS 13, *) {
        } else {
            _ = delegate.tableView!(tableView, editActionsForRowAt: iPath)
        }
        _ = delegate.tableView!(tableView, shouldIndentWhileEditingRowAt: iPath)
        delegate.tableView!(tableView, willBeginEditingRowAt: iPath)
        delegate.tableView!(tableView, didEndEditingRowAt: iPath)
        _ = delegate.tableView!(tableView, targetIndexPathForMoveFromRowAt: iPath, toProposedIndexPath: iPath)
        _ = delegate.tableView!(tableView, indentationLevelForRowAt: iPath)
        if #available(iOS 13, *) {
        } else {
            _ = delegate.tableView!(tableView, shouldShowMenuForRowAt: iPath)
            _ = delegate.tableView!(tableView, canPerformAction: #selector(UITableViewTests.setUp), forRowAt: iPath, withSender: nil)
            _ = delegate.tableView!(tableView, performAction: #selector(UITableViewTests.setUp), forRowAt: iPath, withSender: nil)
        }
        _ = delegate.tableView!(tableView, canFocusRowAt: iPath)
        _ = delegate.indexPathForPreferredFocusedView!(in: tableView)
        _ = datasource.tableView(tableView, numberOfRowsInSection: 0)
        _ = datasource.tableView(tableView, cellForRowAt: iPath)
        _ = datasource.numberOfSections!(in: tableView)
        _ = datasource.tableView!(tableView, titleForHeaderInSection: 0)
        _ = datasource.tableView!(tableView, titleForFooterInSection: 0)
        _ = datasource.tableView!(tableView, canEditRowAt: iPath)
        _ = datasource.tableView!(tableView, canMoveRowAt: iPath)
        _ = datasource.sectionIndexTitles!(for: tableView)
        _ = datasource.tableView!(tableView, sectionForSectionIndexTitle: "", at: 0)
        datasource.tableView!(tableView, commit: .delete, forRowAt: iPath)
        datasource.tableView!(tableView, moveRowAt: iPath, to: iPath)
        if #available(iOS 13, *) {
            _ = delegate.tableView!(tableView, shouldBeginMultipleSelectionInteractionAt: iPath)
            delegate.tableView!(tableView, didBeginMultipleSelectionInteractionAt: iPath)
            delegate.tableViewDidEndMultipleSelectionInteraction!(tableView)
        }

        waitForExpectations(timeout: 0.2)
    }
    
    class ASubClass: UITableView {}
    
    func testSubclassing() {
        let tableView = UITableView()
            .accessoryButtonTappedForRowWith { _ in
            }
            .didScroll { _ in }
        XCTAssertNotNil(tableView.delegate?.tableView?(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 0, section: 0)))
        
        let aSubClass = ASubClass()
            .accessoryButtonTappedForRowWith { _ in
            }
            .didScroll { _ in }
        XCTAssertNotNil(aSubClass.delegate?.tableView?(aSubClass, accessoryButtonTappedForRowWith: IndexPath(row: 0, section: 0)))
    }
    
    func testTableViewMethodExpectations() {
        let lastKnownDelegateCount: Int
        if #available(iOS 13, *) {
            lastKnownDelegateCount = 48
        } else {
            lastKnownDelegateCount = 41
        }
        let lastKnownDataSourceCount = 11
        
        let delegateCount = numberOfMethods(in: UITableViewDelegate.self)
        let dataSourceCount = numberOfMethods(in: UITableViewDataSource.self)
        
        XCTAssertEqual(lastKnownDelegateCount, delegateCount)
        XCTAssertEqual(lastKnownDataSourceCount, dataSourceCount)
    }
    
    fileprivate func numberOfMethods(in p: Protocol) -> Int {
        var optionalCount: UInt32 = 0
        var requiredCount: UInt32 = 0
        _ = protocol_copyMethodDescriptionList(p, false, true, &optionalCount)
        _ = protocol_copyMethodDescriptionList(p, true, true, &requiredCount)
        return Int(optionalCount + requiredCount)
    }
}
