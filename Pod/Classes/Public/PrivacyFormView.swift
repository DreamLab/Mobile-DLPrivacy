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

    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorRetryButton: UIButton!

    private weak var delegate: PrivacyFormViewDelegate?

    // MARK: Instance

    /// Return PrivacyFormView instance loaded from nib
    ///
    /// - Returns: PrivacyFormView
    static func loadFromNib() -> PrivacyFormView {
        let formViewNib = UINib(nibName: "\(PrivacyFormView.self)", bundle: Privacy.resourcesBundle)
        let formView = formViewNib.instantiate(withOwner: self, options: nil).first as? PrivacyFormView

        // swiftlint:disable force_unwrapping
        return formView!
        // swiftlint:enable force_unwrapping
    }

    // MARK: Life cycle

    public override func awakeFromNib() {
        super.awakeFromNib()

        loadTranslations()
    }
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

    // MARK: Actions

    @IBAction func onRetryButtonTouch(_ sender: Any) {
        delegate?.privacyViewRequestingReload(self)
    }

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
        let bundle = Privacy.resourcesBundle

        errorLabel.text = NSLocalizedString("DLPrivacy.errorView.errorNoInternet", tableName: nil, bundle: bundle, value: "", comment: "")
        let retryTitle = NSLocalizedString("DLPrivacy.errorView.retryButton", tableName: nil, bundle: bundle, value: "", comment: "")
        errorRetryButton.setTitle(retryTitle, for: .normal)
    }

    // MARK: Configuration

    /// Add WKWebView to view hierarchy and assign delegate
    ///
    /// - Parameters:
    ///   - webView: WKWebView
    ///   - delegate: PrivacyFormViewDelegate
    func configure(with webView: WKWebView, delegate: PrivacyFormViewDelegate) {
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
    ///   - buttonTextColor: UIColor
    ///   - font: UIFont
    func configure(withThemeColor color: UIColor, buttonTextColor: UIColor, font: UIFont) {
        loadingIndicator.color = color
        errorRetryButton.backgroundColor = color
        errorRetryButton.setTitleColor(buttonTextColor, for: .normal)

        errorLabel.font = font.withSize(errorLabel.font.pointSize)

        if let label = errorRetryButton.titleLabel {
            errorRetryButton.titleLabel?.font = font.withSize(label.font.pointSize)
        }
    }
}
