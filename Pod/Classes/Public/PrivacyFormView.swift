//
//  PrivacyFormView.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// View presenting loading, error and consents form
public class PrivacyFormView: UIView {

    /// Loading view
    private lazy var loadingView: PrivacyLoadingView = PrivacyLoadingView.loadFromNib()

    /// Error view
    private lazy var errorView: PrivacyErrorView = PrivacyErrorView.loadFromNib()

    /// App restart info view
    private lazy var restartView: PrivacyAppRestartInfoView = PrivacyAppRestartInfoView.loadFromNib()

    /// Internal module delegate
    private weak var delegate: PrivacyFormViewDelegate?

    /// Currently shown state view
    private weak var currentlyShownStateView: UIView?
}

// MARK: Public interface
public extension PrivacyFormView {

    /// Show consents welcome screen
    func showConsentsWelcomeScreen() {
        delegate?.privacyViewRequestingWelcomeScreen(self)
    }

    /// Show consents settings screen
    func showConsentsSettingsScreen() {
        delegate?.privacyViewRequestingSetingsScreen(self)
    }
}

// MARK: Internal
extension PrivacyFormView {

    // MARK: State

    /// Show loading indicator
    func showLoadingState() {
        loadingView.startAnimation()
        addSubviewFullscreen(loadingView)

        currentlyShownStateView?.removeFromSuperview()
        currentlyShownStateView = loadingView
    }

    /// Show error view with retry button
    func showErrorState() {
        addSubviewFullscreen(errorView)

        currentlyShownStateView?.removeFromSuperview()
        currentlyShownStateView = errorView
    }

    /// Show WebView with its content
    func showContentState() {
        currentlyShownStateView?.removeFromSuperview()
    }

    /// Show app restart info view
    func showAppRestartInfoView() {
        addSubviewFullscreen(restartView)

        currentlyShownStateView?.removeFromSuperview()
        currentlyShownStateView = restartView
    }

    // MARK: Configuration

    /// Add WKWebView to view hierarchy and assign delegate
    ///
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - delegate: PrivacyFormViewDelegate
    func configure(with webView: WKWebView, delegate: PrivacyFormViewDelegate) {
        self.delegate = delegate
        errorView.delegate = delegate
        restartView.delegate = delegate

        addSubviewFullscreen(webView, at: 0)
    }

    /// Configure loading view and error view using theme color
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - buttonTextColor: UIColor
    ///   - font: UIFont
    func configure(withThemeColor color: UIColor, buttonTextColor: UIColor, font: UIFont) {
        loadingView.configure(color)
        errorView.configure(withThemeColor: color, buttonTextColor: buttonTextColor, font: font)
        restartView.configure(withThemeColor: color, buttonTextColor: buttonTextColor, font: font)
    }
}
