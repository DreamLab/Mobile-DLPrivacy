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

    func privacyViewRequestingClose(_ view: PrivacyFormView) {
        let consents = getSDKConsents(Array(allAvailableSDK.keys))
        delegate?.privacyModule(self, shouldHideConsentsForm: view, andApplyConsents: consents)
    }

    func privacyViewRequestingSetingsScreen(_ view: PrivacyFormView) {
        performAction(.showSettingsScreen)
    }

    func privacyViewRequestingWelcomeScreen(_ view: PrivacyFormView) {
        performAction(.showWelcomeScreen)
    }
}
