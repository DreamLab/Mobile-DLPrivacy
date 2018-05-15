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
    public let pubConsent: String

    /// Value
    public let adpConsent: String

    /// Value
    public let venConsent: String

    // MARK: Init

    /// Initializer
    ///
    /// - Parameters:
    ///   - pubConsent: String
    ///   - adpConsent: String
    ///   - venConsent: String
    public init(pubConsent: String, adpConsent: String, venConsent: String) {
        self.pubConsent = pubConsent
        self.adpConsent = adpConsent
        self.venConsent = venConsent
    }
}

// MARK: Internal
extension PrivacyConsentsData {

    static func initialize(from dictionay: [String: String]) -> PrivacyConsentsData {
        let pub = dictionay["pubconsent"] ?? ""
        let adp = dictionay["adpconsent"] ?? ""
        let ven = dictionay["venconsent"] ?? ""

        return PrivacyConsentsData(pubConsent: pub, adpConsent: adp, venConsent: ven)
    }
}
