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

    /// CMP purpose ids key
    private static let cmpPurposeIdsKey = "purposes"

    // MARK: Delegate

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let messageDict = message.body as? [String: Any],
            let eventMessage = messageDict[Privacy.cmpEventNameKey] as? String,
            let cmpEvent = CMPEvent(from: eventMessage) else {
            DDLogError("Failed to parse WKScriptMessage: \(message.body)")
            return
        }

        switch cmpEvent {
        case .formLoaded:
            DDLogInfo("CMP form was loaded but is not ready yet")

        case .formReady:
            DDLogInfo("CMP form ready, cancelling loading timer...")

            webViewLoadingTimer?.invalidate()
            webViewLoadingTimer = nil

            moduleState = .cmpLoaded

        case .formSubmitted:
            DDLogInfo("JavaScript send info that consents form was completed by the user")
            formSubmittedAction()

        case .welcomeScreenVisible, .settingsScreenVisible:
            DDLogInfo("JavaScript shown CMP content view")
            privacyView.showContentState()

        case .getVendorConsent:
            DDLogInfo("Vendor consent was returned from JavaScript: \(messageDict)")
            handleConsentResponse(messageDict)

        case .canShowPersonalizedAds:
            let canAdsBePersonalized = (messageDict[Privacy.cmpEventPayloadKey] as? Bool) ?? false
            DDLogInfo("Can show personalized ads JavaScript response: \(canAdsBePersonalized)")

            // Store in cache
            consentsCache.canShowPersonalizedAds = canAdsBePersonalized

        case .consentsData:
            DDLogInfo("Consent data JavaScript response: \(messageDict)")
            handleConsentsData(messageDict)

        case .getPurposeConsent:
            DDLogInfo("Purpose consents returned from JavaScript")
            handlePurposeConsent(messageDict)

        case .error:
            DDLogInfo("JavaScript listeners for CMP were not added; error was returned.")

            handleCMPLoadingError(NSError(domain: "CMP", code: -1, userInfo: nil))
        }
    }
}

// MARK: Private
private extension Privacy {

    func formSubmittedAction() {
        // Show loading while we are fetching content from JS
        privacyView.showLoadingState()

        currentData = AllConsentData(canShowPersonalizedAds: canShowPersonalizedAds,
                                     internalAnalyticsConsent: internalAnalyticsEnabled,
                                     sdkConsents: getSDKConsents())

        // Request consents for default SDK and other things which will be cached
        performAction(.canShowPersonalizedAds)
        performAction(.getConsentsData)
        performAction(.getPurposeConsent(purpose: .measurement))
        requestConsentsForDefaultSDKs()
    }

    func requestConsentsForDefaultSDKs() {
        // Clear cache
        consentsCache.clearAppSDKCache(Array(allAvailableSDK.keys))

        // Get consent for all predefined SDK
        for sdk in allAvailableSDK.keys {
            guard let mapping = CMPVendorsMapping.sdkMapping[sdk] else {
                continue
            }

            DDLogInfo("Requesting consent for: \(sdk.rawValue) from JavaScript CMP tool")
            performAction(.getVendorConsent(sdk: sdk, mapping: mapping))
        }
    }

    func handleConsentResponse(_ messageDict: [String: Any]) {
        guard let sdkName = messageDict["sdkName"] as? String, let consent = messageDict["consent"] as? Bool else {
            DDLogError("Failed to map consent response for: \(messageDict)")
            return
        }

        let appSDK = AppSDK(rawValue: sdkName)
        let isDefaultSDK = allAvailableSDK.keys.contains(appSDK)

        // Store in cache if this is default SDK, if not call callback
        if isDefaultSDK {
            storeUserConsent(consent, for: appSDK)
        } else {
            let callback = customSDKConsentCallback[appSDK]
            callback??(consent)
            customSDKConsentCallback[appSDK] = nil
        }
    }

    func handleConsentsData(_ messageDict: [String: Any]) {
        var consentsData = messageDict[Privacy.cmpEventPayloadKey] as? [String: Any]

        // Remove values which can't be stored in UserDefaults
        consentsData = consentsData?.filter({ (_, value) -> Bool in
            return !(value is NSNull)
        })

        // Store in cache
        consentsCache.consentsData = consentsData
    }

    func handlePurposeConsent(_ messageDict: [String: Any]) {
        // NOTE: We can in the future handle here all purpose ids and do something with them
        // For now we are only interested in number 5 = ConsentPurpose.measurement

        guard let consent = messageDict[Privacy.cmpEventPayloadKey] as? Bool else {
            DDLogError("Parsing purpose consents failed!")
            return
        }

        DDLogInfo("Retrieved internal analytics purpose consent - \(consent)")

        // Store in cache
        consentsCache.internalAnalyticsConsent = consent
    }
}
