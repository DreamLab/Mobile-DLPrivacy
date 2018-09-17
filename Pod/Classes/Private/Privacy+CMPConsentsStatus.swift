//
//  Privacy+CMPConsentsStatus.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 24.07.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import CocoaLumberjack

/// Functionality related to CMP contents status
extension Privacy {

    // Check if consents stored on thi device are up to date; if not inform about it
    func checkUserConsentsStatus() {
        DDLogInfo("Checking user consents status")

        // Check if we have stored consents status in cache
        guard let consentsStatus = consentsCache.lastConsentsStatus, consentsStatus != .ok else {
            // We don't have stored consents status or this status is correct, ask API for update
            DDLogInfo("Stored consents status is: '\(consentsCache.lastConsentsStatus)', module will ask API for update")
            checkUserConsentsStatusInAPI()
            return
        }

        // We have invalid status stored for user consents, we don't have to ask API again for it
        DDLogInfo("Stored invalid user consents status: '\(consentsStatus)', informing delegate...")
        delegate?.privacyModule(self, shouldShowConsentsForm: privacyView)
    }
}

// MARK: Private
private extension Privacy {

    func checkUserConsentsStatusInAPI() {
        DDLogInfo("Asking CMP API for current user consents status...")

        let userContents = consentsData
        cmpApi.getConsentsStatus(for: userContents) { [weak self] status in
            DDLogInfo("CMP consents status from API: \(status.debugDescription)")

            guard let wSelf = self else { return }

            DDLogInfo("Storing consents status from API in cache")
            wSelf.consentsCache.lastConsentsStatus = status

            guard let status = status, status != .ok else { return }

            DDLogInfo("Sending application 'should show consents form again' based on received CMP consents status from API")
            DispatchQueue.main.async {
                wSelf.delegate?.privacyModule(wSelf, shouldShowConsentsForm: wSelf.privacyView)
            }
        }
    }
}
