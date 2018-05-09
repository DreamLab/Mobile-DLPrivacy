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
@objc
enum CMPAction: Int {

    case showWelcomeScreen
    case getVendorConsents

    func getJavaScriptCode() -> String {
        switch self {
        case .showWelcomeScreen:
            return """
                window.__cmp('showConsentTool', null, function(result) {
                    webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpWelcomeVisible"});
                });
            """

        case .getVendorConsents:
            return """
            window.__cmp('getVendorConsents', [1, 2, 3, 4], function(result) {
            myLogger('getVendorConsents callback result:\n' + JSON.stringify(result, null, 2));
            });
            """
        }
    }
}
