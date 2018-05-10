//
//  Privacy+PrivacyFormViewDelegate.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 10.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

// MARK: PrivacyFormViewDelegate
extension Privacy: PrivacyFormViewDelegate {

    func privacyViewRequestingReload(_ view: PrivacyFormView) {
        privacyView.showLoadingState()
        loadCMPSite()
    }

    func privacyViewRequestingSetingsScreen(_ view: PrivacyFormView) {
        performAction(.showWelcomeScreen) // TODO: [ASZ]
    }

    func privacyViewRequestingWelcomeScreen(_ view: PrivacyFormView) {
        performAction(.showWelcomeScreen)
    }
}
