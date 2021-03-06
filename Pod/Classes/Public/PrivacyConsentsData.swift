//
//  PrivacyConsentsData.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 14.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Class representing privacy consents data
public class PrivacyConsentsData: NSObject {

    /// Value
    @objc public let pubConsent: String?

    /// Value
    @objc public let adpConsent: String?

    /// Value
    @objc public let euConsent: String?

    // MARK: Init

    /// Initializer
    ///
    /// - Parameters:
    ///   - pubConsent: String
    ///   - adpConsent: String
    ///   - euConsent: String
    public init(pubConsent: String?, adpConsent: String?, euConsent: String?) {
        self.pubConsent = pubConsent
        self.adpConsent = adpConsent
        self.euConsent = euConsent
    }
}

// MARK: Internal
extension PrivacyConsentsData {

    static func initialize(from dictionay: [String: Any]) -> PrivacyConsentsData {
        let pubConsent = dictionay["pubConsent"] as? String
        let adpConsent = dictionay["adpConsent"] as? String
        let euConsent = dictionay["euConsent"] as? String

        return PrivacyConsentsData(pubConsent: pubConsent, adpConsent: adpConsent, euConsent: euConsent)
    }
}
