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
public class Privacy: NSObject {

    /// Default CMP Form web site
    let cmpDefaultSite = "https://www.onet.pl/#test_tid=EA-1111111&test_site=TEST&test_area=RODOTEST&test_kwrd=cmp"

    // MARK: Shared instance

    /// Shared instance
    public static let shared = Privacy()

    // MARK: Properties (Internal/Private)

    /// Underlaying "content" view
    let webview: WKWebView

    /// Wrapper view with loading, error and content
    public let privacyView: PrivacyFormView

    /// Module state
    var moduleState: PrivacyModuleState = .cmpLoading {
        didSet {
            guard moduleState == .cmpLoaded else {
                return
            }

            actionsQueue.forEach {
                performAction($0)
            }

            actionsQueue.removeAll()
        }
    }

    /// Actions queue
    var actionsQueue: [CMPAction] = []

    /// JavaScript scripts used in underlaying web view
    private static let jsScripts = ["CMPEventListeners"]

    /// WebKit message handler name for CMP events
    private let cmpMessageHandlerName = "cmpEvents"

    /// All available SDK
    var allAvailableSDK: [AppSDK: Bool] {
        return [
            AppSDK.GoogleMobileAds: false,
            AppSDK.GoogleAnalytics: false,
            AppSDK.Fabric: false,
            AppSDK.Instabug: false,
            AppSDK.Branch: false,
            AppSDK.Pushwoosh: false,
            AppSDK.Firebase: false,
            AppSDK.Gemius: false,
            AppSDK.Bitplaces: false
        ]
    }

    /// Module delegate
    weak var delegate: PrivacyDelegate?

    // MARK: Init

    /// Initializer
    public override init() {
        self.webview = WKWebView(frame: UIScreen.main.bounds, configuration: Privacy.defaultWebViewConfiguration())
        self.privacyView = PrivacyFormView.loadFromNib()

        super.init()

        self.webview.configuration.userContentController.add(WKScriptMessageHandlerWrapper(delegate: self), name: cmpMessageHandlerName)
        self.webview.navigationDelegate = self
        self.privacyView.configure(with: self.webview, delegate: self)
    }

    // MARK: Deinit

    deinit {
        webview.configuration.userContentController.removeScriptMessageHandler(forName: cmpMessageHandlerName)
        webview.navigationDelegate = nil
    }
}

// MARK: Public interface
public extension Privacy {

    /// Configure Privacy module
    /// Calling this method causes loading view state to be set on the view and CMP site load starts
    ///
    /// - Parameters:
    ///   - theme: Theme color used for loading indicator and retry button color
    ///   - buttonTextColor: Color used for retry button text
    ///   - font: Font used in error view
    ///   - delegate: PrivacyDelegate
    func initialize(withThemeColor theme: UIColor,
                    buttonTextColor: UIColor,
                    font: UIFont,
                    delegate: PrivacyDelegate) {
        self.delegate = delegate

        // Configure privacy view and set state to loading
        privacyView.configure(withThemeColor: theme, buttonTextColor: buttonTextColor, font: font)
        privacyView.showLoadingState()

        // Load CMP
        loadCMPSite()
    }

    /// Get PrivacyFormView which should be presented to the user
    ///
    /// - Returns: PrivacyFormView
    func getPrivacyConsentsView() -> PrivacyFormView {
        return privacyView
    }

    /// Get user consents for given SDK
    ///
    /// There are many predefined SDK, for example AppSDK.GoogleAnalytics.
    /// AppSDK is an enum so you can see for yourself what is already defined.
    ///
    /// If something you need is not defined, you can create your own value and pass to Privacy module using construction like this:
    /// AppSDK(rawValue: "mySDKCodeName")
    ///
    /// - Parameter sdk: [AppSDK]
    /// - Returns: Dictionary where AppSDK is a key, value is either true or false (true if user agreed for given SDK)
    func getSDKConsents(_ sdk: [AppSDK]) -> [AppSDK: Bool] {
        // TODO: [ASZ]

        return [:]
    }

    /// Check if user was already asked about consents (so we don't have to show this form at app start)
    ///
    /// - Returns: True if user was already asked and submitted the privacy form
    func didAskUserForConsents() -> Bool {
        // TODO: [ASZ]

        return false
    }
}

// MARK: Internal
extension Privacy {

    // MARK: WKWebView config

    /// Extend WKWebView configuration by adding user content controller and JS event listeners
    ///
    /// - Returns: WKWebViewConfiguration
    static func defaultWebViewConfiguration() -> WKWebViewConfiguration {
        let wkUserController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = wkUserController

        // Insert scripts
        Privacy.jsScripts.compactMap {
            guard let url = Privacy.resourcesBundle.url(forResource: $0, withExtension: "js"),
                let jsScript = try? String(contentsOf: url) else {
                return nil
            }

            return WKUserScript(source: jsScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)

        }.forEach {
            wkUserController.addUserScript($0)
        }

        return config
    }

    // MARK: CMP site loading

    /// Load CMP site into WKWebView
    func loadCMPSite() {
        guard let cmpURL = URL(string: cmpDefaultSite) else {
            DDLogError("CMP site url is not valid!: \(cmpDefaultSite)")
            return
        }

        let request = URLRequest(url: cmpURL)
        webview.load(request)
    }

    /// Handle WKWebView error and show proper error state
    ///
    /// - Parameter error: Error
    func handleCMPLoadingError(_ error: Error) {
        guard (error as NSError).code == NSURLErrorNotConnectedToInternet else {
            // Call delegate that privacy view should be closed and return all consents set to false
            delegate?.privacyModule(self, shouldHideConsentsForm: privacyView, andApplyConsents: allAvailableSDK)
            return
        }

        privacyView.showErrorState()
        moduleState = .cmpError
    }

    // MARK: JavaScript evaluation / CMP actions

    /// Sends message to JavaScript to perform desired action
    ///
    /// - Parameter cmpAction: CMPAction
    func performAction(_ cmpAction: CMPAction) {
        guard moduleState == .cmpLoaded else {
            DDLogInfo("CMP site is not yet loaded, adding action to queue: \(cmpAction.rawValue)")
            actionsQueue.append(cmpAction)
            return
        }

        webview.evaluateJavaScript(cmpAction.javaScriptCode, completionHandler: nil)
    }

    // MARK: Consents

    /// Store user consents in cache and call delegate that privacy view should be closed
    ///
    /// - Parameter consents: User consents settings
    func storeUserConsents(_ consents: [String: Any]) {
        // TODO: [ASZ]

        guard privacyView.shouldAppRestartViewBeShown else {
            delegate?.privacyModule(self, shouldHideConsentsForm: privacyView, andApplyConsents: allAvailableSDK)
            return
        }

        privacyView.showAppRestartInfoView()
    }
}
