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
    public let euConsent: String

    // MARK: Init

    /// Initializer
    ///
    /// - Parameters:
    ///   - pubConsent: String
    ///   - adpConsent: String
    ///   - venConsent: String
    public init(pubConsent: String, adpConsent: String, euConsent: String) {
        self.pubConsent = pubConsent
        self.adpConsent = adpConsent
        self.euConsent = euConsent
    }
}

// MARK: Internal
extension PrivacyConsentsData {

    static func initialize(from dictionay: [String: String]) -> PrivacyConsentsData {
        let pubConsent = dictionay["pubconsent"] ?? ""
        let adpConsent = dictionay["adpconsent"] ?? ""
        let euConsent = dictionay["euconsent"] ?? ""

        return PrivacyConsentsData(pubConsent: pubConsent, adpConsent: adpConsent, euConsent: euConsent)
    }
}
