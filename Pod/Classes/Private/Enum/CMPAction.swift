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
/// - getVendorConsent: Get consent for given SDK
/// - shouldShowConsentsForm: Check if vendors list has changed and app should show again consents form
/// - canShowPersonalizedAds: Check if application can show personalized ads based on user consents
/// - getConsentsData: Get consents identifiers and values
/// - getPurposesConsent: Get consent for purpose category
enum CMPAction {

    case showWelcomeScreen
    case showSettingsScreen
    case getVendorConsent(sdk: AppSDK, mapping: CMPVendorsMapping.CMPMapping)
    case shouldShowConsentsForm
    case canShowPersonalizedAds
    case getConsentsData
    case getPurposesConsent(purposes: [ConsentPurpose])

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
            window.__cmp('showConsentTool', {"page": "advanced"}, function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpSettingsVisible"});
            });
            """

        case .getVendorConsent(let sdk, let mapping):
            let sdkName = sdk.rawValue
            let vendorName = mapping.vendorName
            let purpose = mapping.purposeId.flatMap { $0.rawValue }

            return """
            window.dlApi.hasVendorConsentByVendorName("\(vendorName)", \(purpose.description), function (hasConsent) {
                webkit.messageHandlers.cmpEvents.postMessage(
                    {"event": "getVendorConsent", "sdkName": "\(sdkName)", "consent": hasConsent}
                );
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

        case .getConsentsData:
            return """
            dlApi.getConsents(function(data) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "consentsData", "payload": data});
            });
            """

        case .getPurposesConsent(let purposes):
            let purpose = purposes.flatMap { $0.rawValue }

            return """
            window.__cmp('getVendorConsents', null, function(result) {
                webkit.messageHandlers.cmpEvents.postMessage(
                    {"event": "getPurposesConsent", "purposes": \(purpose.description), "payload": result}
                );
            });
            """
        }
    }
}
