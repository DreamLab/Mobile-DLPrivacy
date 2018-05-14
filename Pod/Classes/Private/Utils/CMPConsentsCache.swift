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
    private let sponsoringAdsConsentsKey = "DLPrivacy.sponsoringAdsConsentsKey"

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

    // MARK: Cache (Sponsoring identifiers)

    /// Get sponsoring consent identifiers
    var sponsoringAdsConsents: [String: String]? {
        get {
            return storage.object(forKey: sponsoringAdsConsentsKey) as? [String: String]
        }
        set {
            if newValue == nil {
                storage.removeObject(forKey: sponsoringAdsConsentsKey)
            } else {
                storage.set(newValue, forKey: sponsoringAdsConsentsKey)
            }

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
        let cachedConsents: [Bool] = sdks.flatMap {
            let key = storageKey(for: $0)
            return storage.object(forKey: key) as? Bool
        }

        return cachedConsents.count == sdks.count
    }
}

// MARK: Private
private extension CMPConsentsCache {

    func storageKey(for appSDK: AppSDK) -> String {
        return appSDKConsentKey + appSDK.rawValue
    }
}
