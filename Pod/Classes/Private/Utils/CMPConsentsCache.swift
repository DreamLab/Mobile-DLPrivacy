//
//  CMPConsentsCache.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Cache for CMP user consents for AppSDK
class CMPConsentsCache {

    // MARK: Keys

    private let didAskUserForConsentsKey = "DLPrivacy.didAskUserForConsentsKey"
    private let canShowPersonalizedAdsKey = "DLPrivacy.canShowPersonalizedAdsKey"
    private let consentsDataKey = "DLPrivacy.consentsDataKey"
    private let internalAnalyticsConsentKey = "DLPrivacy.internalAnalyticsConsentKey"

    private let appSDKConsentKey = "DLPrivacy.appSDKConsentKey-"

    // MARK: Storage

    /// Cache storage
    private let storage = UserDefaults.standard

    // MARK: Cache (Consents form)

    /// Did user submited privacy form at least once?
    var didAskUserForConsents: Bool {
        get {
            return storage.bool(forKey: didAskUserForConsentsKey)
        }
        set {
            storage.set(newValue, forKey: didAskUserForConsentsKey)
            storage.synchronize()
        }
    }

    // MARK: Cache (Personalized Ads)

    /// Can application show personalized ads to the user
    var canShowPersonalizedAds: Bool? {
        get {
            return storage.object(forKey: canShowPersonalizedAdsKey) as? Bool
        }
        set {
            if newValue == nil {
                storage.removeObject(forKey: canShowPersonalizedAdsKey)
            } else {
                storage.set(newValue ?? false, forKey: canShowPersonalizedAdsKey)
            }

            storage.synchronize()
        }
    }

    // MARK: Cache (Consents identifiers & values)

    /// Get consent identifiers and values
    var consentsData: [String: Any]? {
        get {
            return storage.object(forKey: consentsDataKey) as? [String: Any]
        }
        set {
            if newValue == nil {
                storage.removeObject(forKey: consentsDataKey)
            } else {
                storage.set(newValue, forKey: consentsDataKey)
            }

            storage.synchronize()
        }
    }

    // MARK: Internal analytics consent

    /// Can we send analytics to internal systems?
    var internalAnalyticsConsent: Bool {
        get {
            return storage.bool(forKey: internalAnalyticsConsentKey)
        }
        set {
            storage.set(newValue, forKey: internalAnalyticsConsentKey)
            storage.synchronize()
        }
    }

    // MARK: Cache (AppSDK)

    /// Get user consent for given SDK
    ///
    /// - Parameter appSDK: AppSDK
    /// - Returns: True if user agreed for given SDK
    func consent(for appSDK: AppSDK) -> Bool {
        let key = storageKey(for: appSDK)
        return storage.bool(forKey: key)
    }

    /// Store user consent for given SDK
    ///
    /// - Parameters:
    ///   - appSDK: AppSDK
    ///   - consent: True if user agreed for given SDK
    func storeConsent(for appSDK: AppSDK, consent: Bool) {
        let key = storageKey(for: appSDK)
        storage.set(consent, forKey: key)
        storage.synchronize()
    }

    /// Clear AppSDK cache
    ///
    /// - Parameter sdks: [AppSDK]
    func clearAppSDKCache(_ sdks: [AppSDK]) {
        for appSDK in sdks {
            let key = storageKey(for: appSDK)
            storage.removeObject(forKey: key)
        }

        storage.synchronize()
    }

    /// Check if we have stored consent for all default SDKs
    ///
    /// - Parameter sdks: [AppSDK]
    /// - Returns: True if all consents are stored
    func hasAllSDKConsentsCached(_ sdks: [AppSDK]) -> Bool {
        let cachedConsents: [Bool] = sdks.compactMap {
            let key = storageKey(for: $0)
            return storage.object(forKey: key) as? Bool
        }

        return cachedConsents.count == sdks.count
    }

    /// Clears storage cache
    func clearStorage() {
        storage.dictionaryRepresentation().keys.forEach { storage.removeObject(forKey: $0) }
        storage.synchronize()
    }
}

// MARK: Private
private extension CMPConsentsCache {

    func storageKey(for appSDK: AppSDK) -> String {
        return appSDKConsentKey + appSDK.rawValue
    }
}
