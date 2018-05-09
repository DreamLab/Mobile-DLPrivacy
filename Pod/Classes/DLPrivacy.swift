//
//  DLPrivacy.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import CocoaLumberjack

/// Main class for DLPrivacy module
public class DLPrivacy: NSObject {

    /// Singleton
    public static let shared = DLPrivacy()

    /// Underlaying "content" view
    private let webview = WKWebView(frame: UIScreen.main.bounds)

    // MARK: Init

    /// Private initializer
    private override init() {
        super.init()

    }









}

// MARK: Public interface

public extension DLPrivacy {

    func initialize() {
        // TODO: [ASZ]


        guard let url = URL(string: "http://10.69.42.31:5000") else {
            return
        }

        let request = URLRequest(url: url)
        webview.load(request)


    }

    func getPrivacyConsentsView() -> UIView {



        return webview
    }

    func showConsentsWelcomeScreen() {


    }

    func showConsentsSettingsScreen() {


    }


}
