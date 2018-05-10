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

    /// Default CMP Form web site
    public static let cmpDefaultSite = "http://10.69.42.31:5000"

    // MARK: Shared instance

    /// Shared instance
    public static let shared = DLPrivacy()

    // MARK: Properties (Internal/Private)

    /// Underlaying "content" view
    let webview: WKWebView

    /// Wrapper view with loading, error and content
    let privacyView: DLPrivacyFormView

    /// JavaScript scripts used in underlaying web view
    static let jsScripts = ["CMPEventListeners"]

    /// WebKit message handler name for CMP events
    private let cmpMessageHandlerName = "cmpEvents"

    /// Module delegate
    weak var delegate: DLPrivacyDelegate?

    // MARK: Init

    /// Initializer
    public override init() {
        self.webview = WKWebView(frame: UIScreen.main.bounds, configuration: DLPrivacy.defaultWebViewConfiguration())
        self.privacyView = DLPrivacyFormView.loadFromNib()

        super.init()

        self.webview.configuration.userContentController.add(WKScriptMessageHandlerWrapper(delegate: self), name: cmpMessageHandlerName)
        self.webview.navigationDelegate = self
        self.privacyView.configure(with: self.webview)
    }

    // MARK: Deinit

    deinit {
        webview.configuration.userContentController.removeScriptMessageHandler(forName: cmpMessageHandlerName)
    }
}

// MARK: Public interface
public extension DLPrivacy {

    /// Configure DLPrivacy module
    /// Calling this method causes loading view state to be set on the view and CMP site load starts
    ///
    /// - Parameters:
    ///   - theme: Theme color used for loading indicator and retry button color
    ///   - site: Optional - if different CMP site then default should be used
    func initialize(withThemeColor theme: UIColor, cmpSite site: String = DLPrivacy.cmpDefaultSite) {
        // Configure privacy view and set state to loading
        privacyView.configure(withThemeColor: theme)
        privacyView.showLoadingState()

        // Load CMP
        loadCMPSite(site)
    }

    /// Get DLPrivacyFormView which should be presented to the user
    ///
    /// - Returns: DLPrivacyFormView
    func getPrivacyConsentsView() -> DLPrivacyFormView {
        return privacyView
    }

    /// Get user consents for given SDK
    ///
    /// - Parameter sdk: [AppSDK]
    /// - Returns: Dictionary where AppSDK is a key, value is either true or false (true if user agreed for given SDK)
    func getSDKConsents(_ sdk: [AppSDK]) -> [AppSDK: Bool] {
        // TODO: [ASZ]

        return [:]
    }
}

// MARK: Internal
extension DLPrivacy {

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

    // MARK: CMP site loading

    /// Load CMP site into WKWebView
    ///
    /// - Parameter site: String
    func loadCMPSite(_ site: String) {
        guard let cmpURL = URL(string: site) else {
            DDLogError("CMP site url is not valid!: \(site)")
            return
        }

        let request = URLRequest(url: cmpURL)
        webview.load(request)
    }

    // MARK: JavaScript evaluation / CMP actions

    /// Sends message to JavaScript to perform desired action
    ///
    /// - Parameter cmpAction: CMPAction
    func performAction(_ cmpAction: CMPAction) {
        webview.evaluateJavaScript(cmpAction.getJavaScriptCode(), completionHandler: nil)
    }
}
