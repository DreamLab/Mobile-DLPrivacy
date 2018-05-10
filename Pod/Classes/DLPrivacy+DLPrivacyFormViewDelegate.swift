//
//  DLPrivacy+DLPrivacyFormViewDelegate.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 10.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

// MARK: DLPrivacyFormViewDelegate
extension DLPrivacy: DLPrivacyFormViewDelegate {

    func privacyViewRequestingReload(_ view: DLPrivacyFormView) {
        privacyView.showLoadingState()
        loadCMPSite(cmpSiteToLoad ?? DLPrivacy.cmpDefaultSite)
    }

    func privacyViewRequestingSetingsScreen(_ view: DLPrivacyFormView) {
        performAction(.showWelcomeScreen) // TODO: [ASZ]
    }

    func privacyViewRequestingWelcomeScreen(_ view: DLPrivacyFormView) {
        performAction(.showWelcomeScreen)
    }
}
