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

    /// Module state
    var moduleState: DLPrivacyModuleState = .cmpLoading {
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
    fileprivate static let jsScripts = ["CMPEventListeners"]

    /// WebKit message handler name for CMP events
    fileprivate let cmpMessageHandlerName = "cmpEvents"

    /// All available SDK
    fileprivate var allAvailableSDK: [AppSDK: Bool] {
        return [
            AppSDK.DFPAds: false,
            AppSDK.GoogleAnalytics: false,
            AppSDK.Fabric: false,
            AppSDK.Instabug: false,
            AppSDK.BranchIO: false,
            AppSDK.Pushwoosh: false,
            AppSDK.Firebase: false,
            AppSDK.Gemius: false,
            AppSDK.Bitplaces: false
        ]
    }

    /// Module delegate
    weak var delegate: DLPrivacyDelegate?

    /// CMP site to load
    var cmpSiteToLoad: String?

    // MARK: Init

    /// Initializer
    public override init() {
        self.webview = WKWebView(frame: UIScreen.main.bounds, configuration: DLPrivacy.defaultWebViewConfiguration())
        self.privacyView = DLPrivacyFormView.loadFromNib()

        super.init()

        self.webview.configuration.userContentController.add(WKScriptMessageHandlerWrapper(delegate: self), name: cmpMessageHandlerName)
        self.webview.navigationDelegate = self
        self.privacyView.configure(with: self.webview, delegate: self)
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
    ///   - retryTextColor: Color used for retry button text color
    ///   - delegate: DLPrivacyDelegate
    ///   - site: Optional - if different CMP site then default should be used
    func initialize(withThemeColor theme: UIColor,
                    retryTextColor: UIColor,
                    delegate: DLPrivacyDelegate,
                    cmpSite site: String = DLPrivacy.cmpDefaultSite) {
        self.delegate = delegate

        // Configure privacy view and set state to loading
        privacyView.configure(withThemeColor: theme, retryTextColor: retryTextColor)
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
        cmpSiteToLoad = site

        guard let cmpURL = URL(string: site) else {
            DDLogError("CMP site url is not valid!: \(site)")
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
            delegate?.dlPrivacyModule(self, shouldHideConsentsForm: privacyView, andApplyConsents: allAvailableSDK)
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

        webview.evaluateJavaScript(cmpAction.getJavaScriptCode(), completionHandler: nil)
    }

    // MARK: Consents

    /// Store user consents in cache and call delegate that privacy view should be closed
    ///
    /// - Parameter consents: User consents settings
    func storeUserConsents(_ consents: [String: Any]) {
        // TODO: [ASZ]


        delegate?.dlPrivacyModule(self, shouldHideConsentsForm: privacyView, andApplyConsents: allAvailableSDK)
    }
}
