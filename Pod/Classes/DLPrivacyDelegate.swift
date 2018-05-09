//
//  DLPrivacyDelegate.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol DLPrivacyDelegate: class {

    func dlPrivacyModule(_ module: DLPrivacy, shouldShowConsentsForm form: UIView)

    func dlPrivacyModule(_ module: DLPrivacy, shouldHideConsentsForm applyingConsents: [String: Bool]) // TODO: [ASZ] replace for something else this dictionary
}
