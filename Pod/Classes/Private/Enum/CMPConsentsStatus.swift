//
//  CMPConsentsStatus.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 24.07.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

/// Enum representing status for user consents data returned by CMP API
///
/// - empty: Contents are empty
/// - invalid: Consents are invalid
/// - outdated: Consents are outdated
/// - ok: Consents are correct and up to date
enum CMPConsentsStatus: String {

    case empty
    case invalid
    case outdated
    case ok

    /// Initialize CMPConsentsStatus from API status value
    ///
    /// - Parameter apiStatus: String
    init?(from apiStatus: String) {
        let normalizedStatus = apiStatus.lowercased()

        guard let status = CMPConsentsStatus(rawValue: normalizedStatus) else {
            return nil
        }

        self = status
    }
}
