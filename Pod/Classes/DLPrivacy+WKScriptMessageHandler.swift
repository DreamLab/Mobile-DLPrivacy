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

    private static let cmpEventNameKey = "event"

    private static let cmpEventPayloadKey = "payload"

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageDict = message.body as? [String: Any],
            let eventMessage = messageDict[DLPrivacy.cmpEventNameKey] as? String,
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

            performAction(.getVendorConsents)

            return
        case .welcomeScreenVisible:
            // TODO:[ ASZ] Hide loading
            return
        case .vendorsConsentsReceived:
            // todo

            print("payload: \(messageDict["payload"] as? [String: Any])")

            return
        case .error:
            // TODO
            return
        }
    }
}
