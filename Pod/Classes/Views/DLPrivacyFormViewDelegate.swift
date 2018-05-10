//
//  DLPrivacyFormViewDelegate.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 10.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

protocol DLPrivacyFormViewDelegate: class {

    func privacyViewRequestingWelcomeScreen(_ view: DLPrivacyFormView)

    func privacyViewRequestingSetingsScreen(_ view: DLPrivacyFormView)

    func privacyViewRequestingReload(_ view: DLPrivacyFormView)
}
