//
//  WKScriptMessageHandlerWrapper.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import WebKit

/// Wrapper for weak delegate passed to WKUserContentController
class WKScriptMessageHandlerWrapper: NSObject, WKScriptMessageHandler {

    /// Weak delegate (original)
    private weak var delegate: WKScriptMessageHandler?

    /// Initializer
    ///
    /// - Parameter delegate: WKScriptMessageHandler
    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }

    // MARK: WKScriptMessageHandler

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
