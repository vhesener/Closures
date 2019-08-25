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

class UICollectionViewTests: XCTestCase {
    
    func testCollectionViewDelegation() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let exp = expectation(description: "Not all methods called")
        exp.expectedFulfillmentCount = 33
        
        collectionView.willDisplay { _,_ in
            exp.fulfill()
        }
        collectionView.willDisplaySupplementaryView { _,_ in
            exp.fulfill()
        }
        collectionView.didEndDisplaying { _,_ in
            exp.fulfill()
        }
        collectionView.didEndDisplayingSupplementaryView { _,_ in
            exp.fulfill()
        }
        collectionView.shouldHighlightItemAt { _ in
            exp.fulfill()
            return true
        }
        collectionView.didHighlightItemAt { _ in
            exp.fulfill()
        }
        collectionView.didUnhighlightItemAt { _ in
            exp.fulfill()
        }
        collectionView.shouldSelectItemAt { _ in
            exp.fulfill()
            return true
        }
        collectionView.shouldDeselectItemAt { _ in
            exp.fulfill()
            return true
        }
        collectionView.didSelectItemAt { _ in
            exp.fulfill()
        }
        collectionView.didDeselectItemAt { _ in
            exp.fulfill()
        }
        collectionView.shouldShowMenuForItemAt { _ in
            exp.fulfill()
            return true
        }
        collectionView.canPerformAction {_,_,_ in
            exp.fulfill()
            return true
        }
        collectionView.performAction { _,_,_ in
            exp.fulfill()
        }
        collectionView.transitionLayoutForOldLayout {
            exp.fulfill()
            return UICollectionViewTransitionLayout(currentLayout: $0, nextLayout: $1)
        }
        collectionView.targetContentOffsetForProposedContentOffset { _ in
            exp.fulfill()
            return .zero
        }
        collectionView.targetIndexPathForMoveFromItemAt {
            exp.fulfill()
            return $1
        }
        collectionView.canFocusItemAt { _ in
            exp.fulfill()
            return true
        }
        collectionView.indexPathForPreferredFocusedViewIn {
            exp.fulfill()
            return nil
        }
        collectionView.cellForItemAt { _ in
            exp.fulfill()
            return UICollectionViewCell()
        }
        collectionView.numberOfItemsInSection { _ in
            exp.fulfill()
            return 0
        }
        collectionView.numberOfSectionsIn {
            exp.fulfill()
            return 0
        }
        collectionView.viewForSupplementaryElementOfKind { _,_  in
            exp.fulfill()
            return UICollectionReusableView()
        }
        collectionView.canMoveItemAt { _ in
            exp.fulfill()
            return true
        }
        collectionView.moveItemAt { _,_ in
            exp.fulfill()
        }
        collectionView.indexTitlesFor {
            exp.fulfill()
            return []
        }
        collectionView.indexPathForIndexTitle { _,_ in
            exp.fulfill()
            return IndexPath()
        }
        collectionView.sizeForItemAt { _ in
            exp.fulfill()
            return .zero
        }
        collectionView.insetForSectionAt { _ in
            exp.fulfill()
            return .zero
        }
        collectionView.minimumLineSpacingForSectionAt { _ in
            exp.fulfill()
            return 0
        }
        collectionView.minimumInteritemSpacingForSectionAt { _ in
            exp.fulfill()
            return 0
        }
        collectionView.referenceSizeForHeaderInSection { _ in
            exp.fulfill()
            return .zero
        }
        collectionView.referenceSizeForFooterInSection { _ in
            exp.fulfill()
            return .zero
        }
        
        XCTAssertNotNil(collectionView.delegate)
        XCTAssertNotNil(collectionView.dataSource)
        
        let delegate = collectionView.delegate as! UICollectionViewDelegateFlowLayout
        let datasource = collectionView.dataSource!
        let iPath = IndexPath()
        
        delegate.collectionView!(collectionView, willDisplay: UICollectionViewCell(), forItemAt: iPath)
        delegate.collectionView!(collectionView, willDisplaySupplementaryView: UICollectionViewCell(), forElementKind: "", at: iPath)
        delegate.collectionView!(collectionView, didEndDisplaying: UICollectionViewCell(), forItemAt: iPath)
        delegate.collectionView!(collectionView, didEndDisplayingSupplementaryView: UICollectionViewCell(), forElementOfKind: "", at: iPath)
        
        _ = delegate.collectionView!(collectionView, shouldHighlightItemAt: iPath)
        delegate.collectionView!(collectionView, didHighlightItemAt: iPath)
        delegate.collectionView!(collectionView, didUnhighlightItemAt: iPath)
        _ = delegate.collectionView!(collectionView, shouldSelectItemAt: iPath)
        _ = delegate.collectionView!(collectionView, shouldDeselectItemAt: iPath)
        delegate.collectionView!(collectionView, didSelectItemAt: iPath)
        delegate.collectionView!(collectionView, didDeselectItemAt: iPath)
        if #available(iOS 13, *) {
            exp.expectedFulfillmentCount -= 3
        } else {
            _ = delegate.collectionView!(collectionView, shouldShowMenuForItemAt: iPath)
            _ = delegate.collectionView!(collectionView, canPerformAction: #selector(UICollectionViewTests.setUp), forItemAt: iPath, withSender: nil)
            delegate.collectionView!(collectionView, performAction: #selector(UICollectionViewTests.setUp), forItemAt: iPath, withSender: nil)
        }
        _ = delegate.collectionView!(collectionView, transitionLayoutForOldLayout: collectionView.collectionViewLayout, newLayout: collectionView.collectionViewLayout)
        _ = delegate.collectionView!(collectionView, targetContentOffsetForProposedContentOffset: .zero)
        _ = delegate.collectionView!(collectionView, targetIndexPathForMoveFromItemAt: iPath, toProposedIndexPath: iPath)
        _ = delegate.collectionView!(collectionView, canFocusItemAt: iPath)
        _ = delegate.indexPathForPreferredFocusedView!(in: collectionView)
        _ = datasource.collectionView(collectionView, cellForItemAt: iPath)
        _ = datasource.collectionView(collectionView, numberOfItemsInSection: 0)
        _ = datasource.numberOfSections!(in: collectionView)
        _ = datasource.collectionView!(collectionView, viewForSupplementaryElementOfKind: "", at: iPath)
        _ = datasource.collectionView!(collectionView, canMoveItemAt: iPath)
        _ = datasource.collectionView!(collectionView, moveItemAt: iPath, to: iPath)
        _ = datasource.indexTitles!(for: collectionView)
        _ = datasource.collectionView!(collectionView, indexPathForIndexTitle: "", at: 0)
        _ = delegate.collectionView!(collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: iPath)
        _ = delegate.collectionView!(collectionView, layout: collectionView.collectionViewLayout, insetForSectionAt: 0)
        _ = delegate.collectionView!(collectionView, layout: collectionView.collectionViewLayout, minimumLineSpacingForSectionAt: 0)
        _ = delegate.collectionView!(collectionView, layout: collectionView.collectionViewLayout, minimumInteritemSpacingForSectionAt: 0)
        _ = delegate.collectionView!(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForHeaderInSection: 0)
        _ = delegate.collectionView!(collectionView, layout: collectionView.collectionViewLayout, referenceSizeForFooterInSection: 0)
        
        waitForExpectations(timeout: 0.2)
    }
}
