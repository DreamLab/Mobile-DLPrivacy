//
//  ViewController.swift
//  DLPrivacy
//
//  Created by Konrad Falkowski on 17/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import UIKit

/// Template view controller, to be replaced when needed
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize private module
        DLPrivacy.shared.initialize()

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

        // TODO: [ASZ] Remove async when loading screen is added
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            DLPrivacy.shared.showConsentsWelcomeScreen()
        }
    }
}
