//
//  DLPrivacyFormView.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit
import WebKit

/// View presenting loading, error and consents form
public class DLPrivacyFormView: UIView {

    @IBOutlet fileprivate weak var loadingView: UIView!
    @IBOutlet fileprivate weak var loadingIndicator: UIActivityIndicatorView!

    @IBOutlet fileprivate weak var errorView: UIView!
    @IBOutlet fileprivate weak var errorLabel: UILabel!
    @IBOutlet fileprivate weak var errorRetryButton: UIButton!

    fileprivate weak var delegate: DLPrivacyFormViewDelegate?

    // MARK: Instance

    /// Return DLPrivacyFormView instance loaded from nib
    ///
    /// - Returns: DLPrivacyFormView
    static func loadFromNib() -> DLPrivacyFormView {
        let formViewNib = UINib(nibName: "\(DLPrivacyFormView.self)", bundle: DLPrivacy.resourcesBundle)
        let formView = formViewNib.instantiate(withOwner: self, options: nil).first as? DLPrivacyFormView

        // swiftlint:disable force_unwrapping
        return formView!
        // swiftlint:enable force_unwrapping
    }

    // MARK: Life cycle

    public override func awakeFromNib() {
        super.awakeFromNib()

        loadTranslations()
    }

    // MARK: Actions

    @IBAction func onRetryButtonTouch(_ sender: Any) {
        delegate?.privacyViewRequestingReload(self)
    }
}

// MARK: Public interface
public extension DLPrivacyFormView {

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
extension DLPrivacyFormView {

    // MARK: State

    /// Show loading indicator
    func showLoadingState() {
        loadingIndicator.startAnimating()
        loadingView.isHidden = false

        errorView.isHidden = true
    }

    /// Show error view with retry button
    func showErrorState() {
        errorView.isHidden = false

        loadingView.isHidden = true
        loadingIndicator.stopAnimating()
    }

    /// Show WebView with its content
    func showContentState() {
        loadingView.isHidden = true
        loadingIndicator.stopAnimating()
        errorView.isHidden = true
    }

    // MARK: Localization

    /// Load translated texts into view
    func loadTranslations() {
        let bundle = DLPrivacy.resourcesBundle

        errorLabel.text = NSLocalizedString("DLPrivacy.errorView.errorNoInternet", tableName: nil, bundle: bundle, value: "", comment: "")
        let retryTitle = NSLocalizedString("DLPrivace.errorView.retryButton", tableName: nil, bundle: bundle, value: "", comment: "")
        errorRetryButton.setTitle(retryTitle, for: .normal)
    }

    // MARK: Configuration

    /// Add WKWebView to view hierarchy and assign delegate
    ///
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - delegate: DLPrivacyFormViewDelegate
    func configure(with webView: WKWebView, delegate: DLPrivacyFormViewDelegate) {
        self.delegate = delegate

        webView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(webView, at: 0)

        let views = ["webView": webView]
        let hConstrains = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[webView]-(0)-|",
                                                         options: NSLayoutFormatOptions(),
                                                         metrics: nil,
                                                         views: views)
        let vConstrains = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[webView]-(0)-|",
                                                         options: NSLayoutFormatOptions(),
                                                         metrics: nil,
                                                         views: views)
        addConstraints(hConstrains + vConstrains)
    }

    /// Configure loading view and error view using theme color
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - retryTextColor: UIColor
    func configure(withThemeColor color: UIColor, retryTextColor: UIColor) {
        loadingIndicator.color = color
        errorRetryButton.backgroundColor = color
        errorRetryButton.setTitleColor(retryTextColor, for: .normal)
    }
}
