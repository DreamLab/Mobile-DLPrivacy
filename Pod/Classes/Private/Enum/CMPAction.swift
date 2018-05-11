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
/// - showSettingsScreen: Show consents setting screen
/// - getVendorConsents: Get list of consents for vendors
/// - shouldShowConsentsForm: Check if vendors list has changed and app should show again consents form
/// - canShowPersonalizedAds: Check if application can show personalized ads based on user consents
/// - getSponsoringAdsConsents: Get sponsoring ads consents identifiers
enum CMPAction: String {

    case showWelcomeScreen
    case showSettingsScreen
    case getVendorConsents
    case shouldShowConsentsForm
    case canShowPersonalizedAds
    case getSponsoringAdsConsents

    /// Get JavaScript code for given action
    var javaScriptCode: String {
        switch self {
        case .showWelcomeScreen:
            return """
            window.__cmp('showConsentTool', null, function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpWelcomeVisible"});
            });
            """

        case .showSettingsScreen:
            return """
            window.__cmp('showConsentTool', {page: "advanced"}, function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpSettingsVisible"});
            );
            """

        case .getVendorConsents:
            return """
            window.__cmp('getVendorConsents', null, function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpVendorsConsentsReceived", "payload": result});
            });
            """

        case .shouldShowConsentsForm:
            return """
            window.dlApi.shouldDisplayConsentTool(function() {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "shouldShowConsentsForm"});
            });
            """

        case .canShowPersonalizedAds:
            return """
            window.dlApi.canBePersonalized(function(canBePersonalized) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "canShowPersonalizedAds", "payload": canBePersonalized});
            });
            """

        case .getSponsoringAdsConsents:
            return """
            dlApi.getConsents(function(data) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "sponsoringAdsConsents", "payload": data});
            });
            """
        }
    }
}
