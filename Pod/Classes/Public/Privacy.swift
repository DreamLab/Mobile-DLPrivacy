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
    let cmpDefaultSite = "https://m.onet.pl/?test_kwrd=vappn"
    //let cmpDefaultSite = "http://ocdn.eu/aops/mip/polityka/app_test.html?test_kwrd=vappn"

    /// Default web view timeout
    let defaultWebViewTimeout: TimeInterval = 10

    // MARK: Shared instance

    /// Shared instance
    public static let shared = Privacy()

    // MARK: Properties (Internal/Private)

    /// Underlaying "content" view
    let webview: WKWebView

    /// Web view loading timer
    var webViewLoadingTimer: Timer?

    /// Web view host page loaded?
    var webViewHostPageLoaded = false

    /// Wrapper view with loading, error and content
    public let privacyView: PrivacyFormView

    /// Module state
    var moduleState: PrivacyModuleState = .cmpLoading {
        didSet {
            guard moduleState == .cmpLoaded else {
                return
            }

            actionsQueue.forEach {
                DDLogInfo("Executing action from queue: \($0)")
                performAction($0)
            }

            actionsQueue.removeAll()
        }
    }

    /// Cache
    let consentsCache = CMPConsentsCache()

    /// Actions queue
    var actionsQueue: [CMPAction] = []

    /// JavaScript scripts used in underlaying web view
    private static let jsScripts = ["CMPEventListeners"]

    /// WebKit message handler name for CMP events
    private let cmpMessageHandlerName = "cmpEvents"

    /// All available SDK
    var allAvailableSDK: [AppSDK: Bool] {
        return [
            AppSDK.GoogleAnalytics: false,
            AppSDK.FabricAnswers: false,
            AppSDK.FirebaseAnalytics: false,
            AppSDK.FirebaseRemoteConfig: false,
            AppSDK.Gemius: true, // TODO: [ASZ] For now Gemius is hardcoded to true
            AppSDK.Bitplaces: false,
            AppSDK.GoogleConversionTracking: false
        ]
    }

    /// Should application be killed when enters background?
    private var shouldAppBeKilledWhenEntersBackground = false

    /// Module delegate
    weak var delegate: PrivacyDelegate?

    /// Callback/completion closure for custom SDK consent
    var customSDKConsentCallback = [AppSDK: ((consent: Bool) -> Void)?]()

    // MARK: Init

    /// Initializer
    public override init() {
        self.webview = WKWebView(frame: UIScreen.main.bounds, configuration: Privacy.defaultWebViewConfiguration())
        self.privacyView = PrivacyFormView.loadFromNib()

        super.init()

        self.webview.configuration.userContentController.add(WKScriptMessageHandlerWrapper(delegate: self), name: cmpMessageHandlerName)
        self.webview.navigationDelegate = self
        self.privacyView.configure(with: self.webview, delegate: self)

        let notification = Notification.Name.UIApplicationDidEnterBackground
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: notification, object: nil)
    }

    // MARK: Deinit

    deinit {
        webview.configuration.userContentController.removeScriptMessageHandler(forName: cmpMessageHandlerName)
        webview.navigationDelegate = nil

        NotificationCenter.default.removeObserver(self)
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

        // Configure privacy view
        privacyView.configure(withThemeColor: theme, buttonTextColor: buttonTextColor, font: font)

        // Load CMP
        loadCMPSite()

        // Check if app should show again consents form (if form was already displayed once)
        guard didAskUserForConsents() else {
            return
        }

        performAction(.shouldShowConsentsForm)
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
    /// - Parameter sdks: [AppSDK]
    /// - Returns: Dictionary where AppSDK is a key, value is either true or false (true if user agreed for given SDK)
    func getSDKConsents(_ sdks: [AppSDK]) -> [AppSDK: Bool] {
        var consents = [AppSDK: Bool]()

        for sdk in sdks {
            consents[sdk] = consentsCache.consent(for: sdk)

            // TODO: [ASZ] For now Gemius is hardcoded to true
            if sdk == AppSDK.Gemius {
                consents[AppSDK.Gemius] = true
            }
        }

        return consents
    }

    /// Get user consent for given SDK which is not defined by default in module
    ///
    /// If something you need is not defined, you can create your own value and pass to Privacy module using construction like this:
    /// AppSDK(rawValue: "mySDKCodeName")
    ///
    /// - Parameters:
    ///   - sdk: AppSDK, for example: AppSDK(rawValue: "mySDKCodeName")
    ///   - vendorName: Vendor name defined in CMP
    ///   - purposeId: Array of purpose ids defined in CMP
    ///   - completion: Completion handler
    func getCustomSDKConsent(_ sdk: AppSDK, vendorName: String, purposeId: [Int], completion: ((_ consent: Bool) -> Void)?) {
        customSDKConsentCallback[sdk] = completion

        let mapping = CMPVendorsMapping.CMPMapping(vendorName: vendorName, purposeId: purposeId)
        let action = CMPAction.getVendorConsent(sdk: sdk, mapping: mapping)
        performAction(action)
    }

    /// Check if user was already asked about consents (so we don't have to show this form at app start)
    ///
    /// - Returns: True if user was already asked and submitted the privacy form
    func didAskUserForConsents() -> Bool {
        return consentsCache.didAskUserForConsents
    }

    /// Check whether application can display personalized Google Ads (DFP)
    /// Method is synchronous. Return cached value if present.
    ///
    /// Cache content will be updated when again user submits consents form.
    ///
    /// - Parameter completion: Completion handler
    func canShowPersonalizedAds() -> Bool {
        return consentsCache.canShowPersonalizedAds ?? false
    }

    /// Get consents data
    /// Method is synchronous. Returns cached value if present.
    ///
    /// Cache content will be updated when again user submits consents form.
    ///
    /// - Returns: [String: String]
    func getConsentsData() -> [String: String]? {
        return consentsCache.consentsData
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
        Privacy.jsScripts.flatMap {
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

        // Set loading state
        moduleState = .cmpLoading
        webViewHostPageLoaded = false
        privacyView.showLoadingState()

        // Load web page
        let request = URLRequest(url: cmpURL)
        webview.load(request)

        // Start loading timer
        webViewLoadingTimer = Timer.scheduledTimer(timeInterval: defaultWebViewTimeout,
                                                   target: self,
                                                   selector: #selector(webViewLoadingTimeout),
                                                   userInfo: nil,
                                                   repeats: false)
    }

    /// Handle WKWebView error and show proper error state
    ///
    /// - Parameter error: Error
    func handleCMPLoadingError(_ error: Error) {
        DDLogInfo("Loading web page error: \(error.localizedDescription); \(error as NSError)")

        moduleState = .cmpError

        guard (error as NSError).code == NSURLErrorNotConnectedToInternet else {
            // Call delegate that privacy view should be closed and return all consents set to false
            delegate?.privacyModule(self, shouldHideConsentsForm: privacyView, andApplyConsents: allAvailableSDK)
            return
        }

        privacyView.showErrorState()
    }

    /// Called when web page was not able to load in given time
    @objc
    func webViewLoadingTimeout() {
        webview.stopLoading()

        if webViewHostPageLoaded {
            // Send error manually so we can exist form view
            let error = NSError(domain: "CMP", code: -1, userInfo: nil)
            handleCMPLoadingError(error)
        }
    }

    // MARK: JavaScript evaluation / CMP actions

    /// Sends message to JavaScript to perform desired action
    ///
    /// - Parameter cmpAction: CMPAction
    func performAction(_ cmpAction: CMPAction) {
        guard moduleState == .cmpLoaded else {
            DDLogInfo("CMP site is not yet loaded, adding action to queue: \(cmpAction)")
            actionsQueue.append(cmpAction)

            // If we are in error state, try to load web page again
            if moduleState == .cmpError {
                loadCMPSite()
            }

            return
        }

        webview.evaluateJavaScript(cmpAction.javaScriptCode, completionHandler: nil)
    }

    // MARK: Consents

    /// Store user consents in cache
    ///
    /// Call delegate that form view should be closed if we have all consent for default SDKs
    ///
    /// - Parameters:
    ///   - consent: True / false
    ///   - sdk: AppSDK
    func storeUserConsent(_ consent: Bool, for sdk: AppSDK) {
        // Store consent in cache
        DDLogInfo("Storing in cache consent: \(consent) for \(sdk.rawValue)")
        consentsCache.storeConsent(for: sdk, consent: consent)

        // Check if we have received all consents (for default set of SDKs)
        guard consentsCache.hasAllSDKConsentsCached(Array(allAvailableSDK.keys)) else {
            return
        }

        guard didAskUserForConsents() else {
            consentsCache.didAskUserForConsents = true

            let consents = getSDKConsents(Array(allAvailableSDK.keys))
            delegate?.privacyModule(self, shouldHideConsentsForm: privacyView, andApplyConsents: consents)
            return
        }

        /// Show restart info view and restart app when it goes to background
        privacyView.showAppRestartInfoView()
        shouldAppBeKilledWhenEntersBackground = true
    }

    // MARK: Application background event & app restart

    @objc
    func applicationDidEnterBackground() {
        guard shouldAppBeKilledWhenEntersBackground else {
            return
        }

        exit(0)
    }
}
