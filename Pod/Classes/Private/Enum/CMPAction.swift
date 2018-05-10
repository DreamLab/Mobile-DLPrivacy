//
//  CMPAction.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Actions possible to perform with CMP tool
///
/// - showWelcomeScreen: Show consents welcome screen
/// - getVendorConsents: Get list of consents for vendors
enum CMPAction: String {

    case showWelcomeScreen
    case getVendorConsents

    /// Get JavaScript code for given action
    var javaScriptCode: String {
        switch self {
        case .showWelcomeScreen:
            return """
            window.__cmp('showConsentTool', null, function(result) {
            webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpWelcomeVisible"});
            });
            """

        case .getVendorConsents:
            return """
            window.__cmp('getVendorConsents', null, function(result) {
            webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpVendorsConsentsReceived", "payload": result});
            });
            """
        }
    }
}
