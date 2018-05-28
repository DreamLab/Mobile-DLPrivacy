//
//  PrivacyHelper.swift
//  DLPrivacy
//
//  Created by Falkowski Konrad on 28/05/2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// Helper for Privacy
class PrivacyHelper {

    /// JavaScript scripts used in underlaying web view
    private static let jsScripts = ["CMPCookieSetters", "CMPEventListeners"]

    private var consentsData: PrivacyConsentsData

    /// Initializer
    ///
    /// - Parameter consentsData: Privacy Consents Data
    init(with consentsData: PrivacyConsentsData) {
        self.consentsData = consentsData
    }

    var jsStringWithCookies: String {
        let pubConsent = consentsData.pubConsent ?? ""
        let euConsent = consentsData.euConsent ?? ""
        let adpConsent = consentsData.adpConsent ?? ""

        var jsString = ""
        jsString += pubConsent.isEmpty ? "" : "setCookie('pubconsent','\(pubConsent)');"
        jsString += euConsent.isEmpty ? "" : "setCookie('euconsent','\(euConsent)');"
        jsString += adpConsent.isEmpty ? "" : "setCookie('adpconsent','\(adpConsent)');"

        return jsString
    }

    /// JSScript with cookies
    var cookieSettingsJSScript: WKUserScript? {
        guard !jsStringWithCookies.isEmpty else { return nil }

        return WKUserScript(source: jsStringWithCookies, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }

    // MARK: WKWebView config

    /// Extend WKWebView configuration by adding user content controller and JS event listeners
    ///
    /// - Returns: WKWebViewConfiguration
    static func defaultWebViewConfiguration() -> WKWebViewConfiguration {
        let wkUserController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = wkUserController

        // Insert scripts
        PrivacyHelper.jsScripts.flatMap {
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
}
