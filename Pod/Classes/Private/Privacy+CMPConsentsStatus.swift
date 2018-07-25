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

    func checkUserConsentsStatus() {
        DDLogInfo("Asking CMP API for current user consents status...")

        let userContents = consentsData
        cmpApi.getConsentsStatus(for: userContents) { [weak self] status in
            DDLogInfo("CMP consents status: \(status.debugDescription)")

            guard let wSelf = self, let status = status, status != .ok else { return }

            DDLogInfo("Application 'should show consents form again' based on received CMP consents status")
            DispatchQueue.main.async {
                wSelf.delegate?.privacyModule(wSelf, shouldShowConsentsForm: wSelf.privacyView)
            }
        }
    }
}
