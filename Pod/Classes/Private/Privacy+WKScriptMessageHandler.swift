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

    // swiftlint:disable cyclomatic_complexity

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

        case .shouldShowConsentsForm:
            guard !shouldShowConsentToolAgainEventBeIgnored else {
                return
            }

            DDLogInfo("Application 'should show consents form again' was returned from JavaScript")
            delegate?.privacyModule(self, shouldShowConsentsForm: privacyView)

        case .canShowPersonalizedAds:
            let canAdsBePersonalized = (messageDict[Privacy.cmpEventPayloadKey] as? Bool) ?? false
            DDLogInfo("Can show personalized ads JavaScript response: \(canAdsBePersonalized)")

            // Store in cache
            consentsCache.canShowPersonalizedAds = canAdsBePersonalized

        case .consentsData:
            DDLogInfo("Consent data JavaScript response: \(messageDict)")
            handleConsentsData(messageDict)

        case .getPurposesConsent:
            DDLogInfo("Purpose consents returned from JavaScript")
            handlePurposesConsents(messageDict)

        case .error:
            DDLogInfo("JavaScript listeners for CMP were not added; error was returned.")

            handleCMPLoadingError(NSError(domain: "CMP", code: -1, userInfo: nil))
        }
    }

    // swiftlint:enable cyclomatic_complexity
}

// MARK: Private
private extension Privacy {

    func formSubmittedAction() {
        // Request consents for default SDK and other things which will be cached
        performAction(.canShowPersonalizedAds)
        performAction(.getConsentsData)
        performAction(.getPurposesConsent(purposes: [.measurement]))
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

    func handlePurposesConsents(_ messageDict: [String: Any]) {
        // NOTE: We can in the future handle here all purpose ids and do something with them
        // let purposes = (messageDict[Privacy.cmpPurposeIdsKey] as? [Int])
        // For now we are only interested in number 5 = ConsentPurpose.measurement

        guard let payload = messageDict[Privacy.cmpEventPayloadKey] as? [String: Any],
              let purposeConsents = payload["purposeConsents"] as? [String: Bool] else {
            DDLogError("Parsing purpose consents failed!")
            return
        }

        // Get internal analytics consent
        let analyticsPurpose = ConsentPurpose.measurement
        let consent = purposeConsents["\(analyticsPurpose.rawValue)"] ?? false
        DDLogInfo("Retrieved internal analytics purpose consent - \(consent)")

        // Store in cache
        consentsCache.internalAnalyticsConsent = consent
    }
}
