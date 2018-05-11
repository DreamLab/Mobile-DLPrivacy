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

        // Example

        // First you should initialize Privacy module
        // At this point CMP content site starts loading in background
        Privacy.shared.initialize(withThemeColor: .red, buttonTextColor: .white, font: UIFont.systemFont(ofSize: 10), delegate: self)

        // You can check if application should show privacy form view at app launch
        guard !Privacy.shared.didAskUserForConsents() else {
            return
        }

        // Then simply get view and add it to you application however you like
        // For example:
        let privacyView = Privacy.shared.getPrivacyConsentsView()
        addPrivacyViewFullscreen(privacyView)

        // Tell SDK that consents welcome screen should be shown
        privacyView.showConsentsWelcomeScreen()

        // Or maybe you want to show details (settings) skipping welcome screen
        //privacyView.showConsentsSettingsScreen()

        // After user is done selecting his preferences, you will be informed by PrivacyDelegate about that fact
        // In this delegate method you will also receive all available SDK together with user consents

        // If you want manually check (for example at next app launch) which SDK can be enabled,
        // call "getSDKConsents" passing SDK which you are interested in
        let sdkInMyApp: [AppSDK] = [.GoogleAnalytics, .Fabric]
        _ = Privacy.shared.getSDKConsents(sdkInMyApp)

        // If your SDK is not predefined in Privacy module, you can pass value from rawValue with given SDK codename
        let mySDK = AppSDK(rawValue: "mySDKName")
        DDLogInfo("My SDK enum: \(mySDK)")
    }
}

// MARK: PrivacyDelegate
extension ViewController: PrivacyDelegate {

    func privacyModule(_ module: Privacy, shouldShowConsentsForm form: PrivacyFormView) {
        DDLogInfo("DLPrivacy module should show consents form")
    }

    func privacyModule(_ module: Privacy, shouldHideConsentsForm form: PrivacyFormView, andApplyConsents consents: [AppSDK: Bool]) {
        DDLogInfo("DLPrivacy module should hide consents form")

        form.removeFromSuperview()
    }
}

// MARK: Private
private extension ViewController {

    func addPrivacyViewFullscreen(_ privacyView: PrivacyFormView) {
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
    }
}
