//
//  File.swift
//  
//
//  Created by Alex Ivashko on 15.03.2020.
//

import MessageUI

@available(iOS 9.0, *)
class MailComposeDelegate: NSObject, MFMailComposeViewControllerDelegate, DelegateProtocol {
    fileprivate static var delegates = Set<DelegateWrapper<MFMailComposeViewController, MailComposeDelegate>>()
    
    fileprivate var didFinishWith: ((_ result: MFMailComposeResult, _ error: Error?) -> Void)?
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        didFinishWith?(result, error)
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        case #selector(MailComposeDelegate.mailComposeController(_:didFinishWith:error:)):
            return didFinishWith != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

extension MFMailComposeViewController {

    public convenience init(subject: String,
                            toRecipients: [String]?,
                            ccRecipients: [String]?,
                            bccRecipients: [String]?,
                            body: (body: String, isHTML: Bool),
                            attachment: (data: Data, mimeType: String, fileName: String)) {
        self.init()
        setSubject(subject)
        setToRecipients(toRecipients)
        setCcRecipients(ccRecipients)
        setBccRecipients(bccRecipients)
        setMessageBody(body.body, isHTML: body.isHTML)
        addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.fileName)
    }
    
    @available(iOS 9.0, *)
    @discardableResult
    public func didFinish(handler: @escaping (_ result: MFMailComposeResult, _ error: Error?) -> Void) -> Self {
        update { $0.didFinishWith = handler }
    }

}

@available(iOS 9.0, *)
extension MFMailComposeViewController: DelegatorProtocol {
    @discardableResult
    @objc func update(handler: (_ delegate: MailComposeDelegate) -> Void) -> Self {
        DelegateWrapper.update(self,
                               delegate: MailComposeDelegate(),
                               delegates: &MailComposeDelegate.delegates,
                               bind: MFMailComposeViewController.bind) {
            handler($0.delegate)
        }
        return self
    }

    public func clearClosureDelegates() {
        DelegateWrapper.remove(delegator: self, from: &MailComposeDelegate.delegates)
        MFMailComposeViewController.bind(self, nil)
    }
    
    fileprivate static func bind(_ delegator: MFMailComposeViewController, _ delegate: MailComposeDelegate?) {
        delegator.mailComposeDelegate = nil
        delegator.mailComposeDelegate = delegate
    }
}
