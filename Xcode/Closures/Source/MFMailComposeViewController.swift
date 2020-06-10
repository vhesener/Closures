//
//  MFMailComposeViewController.swift
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

@available(iOS 9.0, *)
extension MFMailComposeViewController {
    public convenience init?(subject: String? = nil,
                            toRecipients: [String]? = nil,
                            ccRecipients: [String]? = nil,
                            bccRecipients: [String]? = nil,
                            body: (body: String, isHTML: Bool)? = nil,
                            attachment: (data: Data, mimeType: String, fileName: String)? = nil,
                            handler: @escaping ((_ result: MFMailComposeResult, _ error: Error?) -> Void)) {
        guard MFMailComposeViewController.canSendMail() else {
            return nil
        }
        self.init()
        if let subject = subject {
            setSubject(subject)
        }
        setToRecipients(toRecipients)
        setCcRecipients(ccRecipients)
        setBccRecipients(bccRecipients)
        if let body = body {
            setMessageBody(body.body, isHTML: body.isHTML)
        }
        if let attachment = attachment {
            addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.fileName)
        }
        didFinish(handler: handler)
    }
    
    @discardableResult
    public func didFinish(handler: @escaping (_ result: MFMailComposeResult, _ error: Error?) -> Void) -> Self {
        update { $0.didFinishWith = handler }
    }
}

@available(iOS 9.0, *)
extension MFMailComposeViewController: DelegatorProtocol {
    @discardableResult
    @objc func update(handler: (_ delegate: MailComposeDelegate) -> Void) -> Self {
        DelegateWrapper.update(
            self,
            delegate: MailComposeDelegate(),
            delegates: &MailComposeDelegate.delegates,
            bind: MFMailComposeViewController.bind
        ) {
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
