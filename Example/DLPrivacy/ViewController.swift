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
        Privacy.shared.initialize(withThemeColor: .red, buttonTextColor: .white, font: UIFont.systemFont(ofSize: 10), delegate: self)

        // Add privacy view to your window hierarchy
        let privacyView = Privacy.shared.getPrivacyConsentsView()
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

// MARK: PrivacyDelegate
extension ViewController: PrivacyDelegate {

    func privacyModule(_ module: Privacy, shouldShowConsentsForm form: PrivacyFormView) {
        DDLogInfo("DLPrivacy module should show consents form")
    }

    func privacyModule(_ module: Privacy, shouldHideConsentsForm form: PrivacyFormView, andApplyConsents consents: [AppSDK: Bool]) {
        DDLogInfo("DLPrivacy module should hide consents form")
    }
}
