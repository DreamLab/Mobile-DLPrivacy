//
//  PrivacyFormViewDelegate.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 10.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

/// Internal protocol used to communicate between Privacy module and form view
protocol PrivacyFormViewDelegate: class {

    /// View wants to show CMP welcome screen
    ///
    /// - Parameter view: PrivacyFormView
    func privacyViewRequestingWelcomeScreen(_ view: PrivacyFormView)

    /// View wants to show CMP settings screen
    ///
    /// - Parameter view: PrivacyFormView
    func privacyViewRequestingSetingsScreen(_ view: PrivacyFormView)

    /// View wants to reload CMP site
    ///
    /// - Parameter view: PrivacyFormView
    func privacyViewRequestingReload(_ view: PrivacyFormView)
}
