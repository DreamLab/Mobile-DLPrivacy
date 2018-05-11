//
//  Privacy+WKScriptMessageHandler.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import WebKit
import CocoaLumberjack

// MARK: WKScriptMessageHandler
extension Privacy: WKScriptMessageHandler {

    /// CMP event name key
    private static let cmpEventNameKey = "event"

    /// CMP event payload key
    private static let cmpEventPayloadKey = "payload"

    // MARK: Delegate

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageDict = message.body as? [String: Any],
            let eventMessage = messageDict[Privacy.cmpEventNameKey] as? String,
            let cmpEvent = CMPEvent(from: eventMessage) else {
            DDLogError("Failed to parse WKScriptMessage: \(message.body)")
            return
        }

        DDLogInfo("Received CMPEvent: \(cmpEvent)")

        switch cmpEvent {
        case .formLoaded:
            // Nothing to here
            return

        case .formReady:
            moduleState = .cmpLoaded

        case .formSubmitted:
            performAction(.getVendorConsents)

        case .welcomeScreenVisible, .settingsScreenVisible:
           privacyView.showContentState()

        case .vendorsConsentsReceived:
            // TODO: [ASZ]
            //print("payload: \(messageDict["payload"] as? [String: Any])")

            storeUserConsents([:])

        case .shouldShowConsentsForm:
            delegate?.privacyModule(self, shouldShowConsentsForm: privacyView)

        case .canShowPersonalizedAds:
            let canAdsBePersonalized = (messageDict[Privacy.cmpEventPayloadKey] as? Bool) ?? false
            personalizedAdsCallback?(canAdsBePersonalized)
            personalizedAdsCallback = nil

        case .sponsoringAdsConsents:
            let sponsoringConsents = messageDict[Privacy.cmpEventPayloadKey] as? [String: Any]
            sponsoringAdsConsentsCallback?(sponsoringConsents)
            sponsoringAdsConsentsCallback = nil

        case .error:
            moduleState = .cmpError
            let error = NSError(domain: "CMP", code: -1, userInfo: nil)
            handleCMPLoadingError(error)
        }
    }
}
