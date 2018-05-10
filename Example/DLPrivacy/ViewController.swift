//
//  ViewController.swift
//  DLPrivacy
//
//  Created by Konrad Falkowski on 17/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import UIKit
import CocoaLumberjack

/// Template view controller, to be replaced when needed
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize private module
        DLPrivacy.shared.initialize(withThemeColor: .red, retryTextColor: .white, delegate: self)

        // Add privacy view to your window hierarchy
        let privacyView = DLPrivacy.shared.getPrivacyConsentsView()
        privacyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(privacyView)

        let views = ["privacyView": privacyView]
        let hConstrains = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[privacyView]-(0)-|",
                                                         options: NSLayoutFormatOptions(),
                                                         metrics: nil,
                                                         views: views)
        let vConstrains = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[privacyView]-(0)-|",
                                                         options: NSLayoutFormatOptions(),
                                                         metrics: nil,
                                                         views: views)
        view.addConstraints(hConstrains + vConstrains)

        // Show consents
        privacyView.showConsentsWelcomeScreen()
    }
}

// MARK: DLPrivacyDelegate
extension ViewController: DLPrivacyDelegate {

    func dlPrivacyModule(_ module: DLPrivacy, shouldShowConsentsForm form: UIView) {
        DDLogInfo("DLPrivacy module should show consents form")
    }

    func dlPrivacyModule(_ module: DLPrivacy, shouldHideConsentsForm form: UIView, andApplyConsents consents: [AppSDK: Bool]) {
        DDLogInfo("DLPrivacy module should hide consents form")
    }
}
