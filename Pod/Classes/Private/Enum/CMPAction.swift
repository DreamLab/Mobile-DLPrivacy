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
/// - getPurposeConsent: Get consent for purpose category
/// - setAppUserId: Set identifier vor vendor in CMP
enum CMPAction {

    case showWelcomeScreen
    case showSettingsScreen
    case getVendorConsent(sdk: AppSDK, mapping: CMPVendorsMapping.CMPMapping)
    case shouldShowConsentsForm
    case canShowPersonalizedAds
    case getConsentsData
    case getPurposeConsent(purpose: ConsentPurpose)
    case setAppUserId(vendorId: String)

    /// Get JavaScript code for given action
    var javaScriptCode: String {
        switch self {
        case .showWelcomeScreen:
            return """
            window.dlApi.showConsentTool(null, function(result) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "cmpWelcomeVisible"});
            });
            """

        case .showSettingsScreen:
            return """
            window.dlApi.showConsentTool("advanced", function () {
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
            window.dlApi.cmp('addEventListener', 'openConsentTool', function(result) {
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
            window.dlApi.getConsents(function (error, consents) {
                webkit.messageHandlers.cmpEvents.postMessage({"event": "consentsData", "payload": consents});
            });
            """

        case .getPurposeConsent(let purpose):
            return """
            window.dlApi.hasPublisherConsent(\(purpose.rawValue), function(result) {
                webkit.messageHandlers.cmpEvents.postMessage(
                    {"event": "getPurposeConsent", "purpose": \(purpose.rawValue), "payload": result}
                );
            });
            """

        case .setAppUserId(let vendorId):
            return """
            window.dlApi.setAppUserId("\(vendorId)");
            """
        }
    }
}
