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
            DDLogInfo("CMP form ready, cancelling loading timer...")

            webViewLoadingTimer?.invalidate()
            webViewLoadingTimer = nil

            moduleState = .cmpLoaded

        case .formSubmitted:
            // Request consents for default SDK and other things which will be cached
            requestConsentsForDefaultSDKs()
            performAction(.canShowPersonalizedAds)
            performAction(.getSponsoringAdsConsents)

        case .welcomeScreenVisible, .settingsScreenVisible:
           privacyView.showContentState()

        case .getVendorConsent:
            handleConsentResponse(messageDict)

        case .shouldShowConsentsForm:
            delegate?.privacyModule(self, shouldShowConsentsForm: privacyView)

        case .canShowPersonalizedAds:
            let canAdsBePersonalized = (messageDict[Privacy.cmpEventPayloadKey] as? Bool) ?? false
            DDLogInfo("Can show personalized ads JavaScript response: \(canAdsBePersonalized)")

            // Store in cache
            consentsCache.canShowPersonalizedAds = canAdsBePersonalized

            // Call callback
            personalizedAdsCallback?(canAdsBePersonalized)
            personalizedAdsCallback = nil

        case .sponsoringAdsConsents:
            let sponsoringConsents = messageDict[Privacy.cmpEventPayloadKey] as? [String: String]
            DDLogInfo("Sponsoring ads consent JavaScript response: \(String(describing: sponsoringConsents))")

            // Store in cache
            consentsCache.sponsoringAdsConsents = sponsoringConsents

            // Call callback
            sponsoringAdsConsentsCallback?(sponsoringConsents)
            sponsoringAdsConsentsCallback = nil

        case .error:
            let error = NSError(domain: "CMP", code: -1, userInfo: nil)
            handleCMPLoadingError(error)
        }
    }
}

// MARK: Private
private extension Privacy {

    func requestConsentsForDefaultSDKs() {
        // Clear cache
        consentsCache.clearAppSDKCache(Array(allAvailableSDK.keys))

        // Get consent for all predefined SDK
        for sdk in allAvailableSDK.keys {
            guard let mapping = CMPVendorsMapping.sdkMapping[sdk] else {
                continue
            }

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
}
