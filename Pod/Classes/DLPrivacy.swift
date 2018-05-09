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

    // MARK: Shared instance

    public static let shared = DLPrivacy()

    // MARK: Properties

    /// Underlaying "content" view
    private let webview: WKWebView

    /// JavaScript scripts used in underlaying web view
    private static let jsScripts = ["CMPEventListeners"]

    /// WebKit message handler name for CMP events
    private let cmpMessageHandlerName = "cmpEvents"

    // MARK: Init

    /// Initializer
    public override init() {
        self.webview = WKWebView(frame: UIScreen.main.bounds, configuration: DLPrivacy.defaultWebViewConfiguration())

        super.init()

        self.webview.configuration.userContentController.add(WKScriptMessageHandlerWrapper(delegate: self), name: cmpMessageHandlerName)
    }

    // MARK: Deinit

    deinit {
        webview.configuration.userContentController.removeScriptMessageHandler(forName: cmpMessageHandlerName)
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
        // TODO: [ASZ]
        return webview
    }

    func showConsentsWelcomeScreen() {
        let action = CMPAction.showWelcomeScreen

        webview.evaluateJavaScript(action.getJavaScriptCode(), completionHandler: nil)

    }

    func showConsentsSettingsScreen() {
        // TODO: [ASZ]
    }
}

// MARK: Private

private extension DLPrivacy {

    // MARK: WKWebView config

    /// Extend WKWebView configuration by adding user content controller and JS event listeners
    ///
    /// - Returns: WKWebViewConfiguration
    static func defaultWebViewConfiguration() -> WKWebViewConfiguration {
        let wkUserController = WKUserContentController()
        let config = WKWebViewConfiguration()

        config.userContentController = wkUserController

        // Insert scripts
        DLPrivacy.jsScripts.compactMap {
            guard let url = DLPrivacy.resourcesBundle.url(forResource: $0, withExtension: "js"),
                let jsScript = try? String(contentsOf: url) else {
                return nil
            }

            return WKUserScript(source: jsScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        }.forEach {
            wkUserController.addUserScript($0)
        }

        return config
    }
}
