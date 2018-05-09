//
//  DLPrivacy+WKScriptMessageHandler.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import WebKit
import CocoaLumberjack

// MARK: WKScriptMessageHandler
extension DLPrivacy: WKScriptMessageHandler {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageDict = message.body as? [String: String],
            let eventMessage = messageDict["event"],
            let cmpEvent = CMPEvent(from: eventMessage) else {
            DDLogError("Failed to parse WKScriptMessage: \(message.body)")
            return
        }

        DDLogInfo("Received CMPEvent: \(cmpEvent.rawValue)")

        switch cmpEvent {
        case .formLoaded:
            // Nothing to here
            return
        case .formReady:
            // TODO
            return
        case .formSubmitted:
            // TODO
            return
        case .welcomeScreenVisible:
            // TODO:[ ASZ] Hide loading
            return
        case .error:
            // TODO
            return
        }
    }
}
