//
//  AllConsentData.swift
//  DLPrivacy
//
//  Created by Kordal Paweł on 21.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Structure holding all the consent data returned by app
/// To be used for comparison with different state and determine if data has changed.
struct AllConsentData {
    private var canShowPersonalizedAds: Bool
    private var internalAnalyticsConsent: Bool
    private var sdkConsents: [AppSDK: Bool]

    /// Check if data differs
    ///
    /// - Parameters:
    ///   - canShowPersonalizedAds: Can show personalized ads?
    ///   - internalAnalyticsConsent: Internal analytics consent
    ///   - sdkConsents: SDK Consents
    /// - Returns: True if any of above differs
    func differsTo(canShowPersonalizedAds: Bool, internalAnalyticsConsent: Bool, sdkConsents: [AppSDK: Bool]) -> Bool {
        return self.canShowPersonalizedAds != canShowPersonalizedAds ||
            self.internalAnalyticsConsent != internalAnalyticsConsent ||
            self.sdkConsents != sdkConsents
    }

    /// Initializer of AllConsentData
    ///
    /// - Parameters:
    ///   - canShowPersonalizedAds: Can show personalized ads?
    ///   - internalAnalyticsConsent: Internal analytics consent
    ///   - sdkConsents: SDK Consents
    init(canShowPersonalizedAds: Bool, internalAnalyticsConsent: Bool, sdkConsents: [AppSDK: Bool]) {
        self.canShowPersonalizedAds = canShowPersonalizedAds
        self.internalAnalyticsConsent = internalAnalyticsConsent
        self.sdkConsents = sdkConsents
    }
}
