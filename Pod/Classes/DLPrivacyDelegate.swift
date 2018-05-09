//
//  DLPrivacyDelegate.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

/// DLPrivacy module delegate
@objc
public protocol DLPrivacyDelegate: class {

    /// Delegate method saying that application should show again consents form
    ///
    /// - Parameters:
    ///   - module: DLPrivacy
    ///   - form: UIView
    func dlPrivacyModule(_ module: DLPrivacy, shouldShowConsentsForm form: UIView)

    /// Delegate method saying that application should close consents form and apply selected consents by the user
    ///
    /// - Parameters:
    ///   - module: DLPrivacy
    ///   - form: UIView
    func dlPrivacyModule(_ module: DLPrivacy, shouldHideConsentsForm form: UIView)
}
