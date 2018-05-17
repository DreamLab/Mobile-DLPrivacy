//
//  PrivacyDelegate.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

/// Privacy module delegate
@objc
public protocol PrivacyDelegate: class {

    // swiftlint:disable function_parameter_count

    /// Delegate method saying that application should show again consents form
    ///
    /// - Parameters:
    ///   - module: Privacy
    ///   - form: PrivacyFormView
    func privacyModule(_ module: Privacy, shouldShowConsentsForm form: PrivacyFormView)

    /// Delegate method saying that application should close consents form and apply selected consents by the user
    ///
    /// - Parameters:
    ///   - module: Privacy
    ///   - form: PrivacyFormView
    ///   - consents: Dictionary with SDK and answer if this SDK can be enabled
    ///   - consentsData: PrivacyConsentsData
    ///   - canShowPersonalizedAds: Bool
    ///   - canReportInternalAnalytics: Bool
    func privacyModule(_ module: Privacy,
                       shouldHideConsentsForm form: PrivacyFormView,
                       andApplyConsents consents: [AppSDK: Bool],
                       consentsData: PrivacyConsentsData,
                       canShowPersonalizedAds: Bool,
                       canReportInternalAnalytics: Bool)
}
