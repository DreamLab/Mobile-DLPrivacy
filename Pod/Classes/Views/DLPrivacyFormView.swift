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

    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet fileprivate weak var loadingIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var errorView: UIView!
    @IBOutlet fileprivate weak var errorLabel: UILabel!
    @IBOutlet fileprivate weak var errorRetryButton: UIButton!

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

    // MARK: State

    func showLoadingState() {
        loadingIndicator.startAnimating()
        loadingView.isHidden = false

        errorView.isHidden = true
    }

    func showErrorState() {


    }

    func showContentState() {


    }

    // MARK: Actions

    @IBAction func onRetryButtonTouch(_ sender: Any) {

    }






    // wspolny protokol dla modulu i view ???
}

// MARK: Public interface

public extension DLPrivacyFormView {

    func showConsentsWelcomeScreen() {
        //performAction(.showWelcomeScreen)
    }

    func showConsentsSettingsScreen() {
        // TODO: [ASZ]
    }
}

// MARK: Internal

extension DLPrivacyFormView {

    // MARK: Localization

    func loadTranslations() {
        let bundle = DLPrivacy.resourcesBundle

        errorLabel.text = NSLocalizedString("DLPrivacy.errorView.errorLabel", tableName: nil, bundle: bundle, value: "", comment: "")
        let retryTitle = NSLocalizedString("DLPrivace.errorView.retryButton", tableName: nil, bundle: bundle, value: "", comment: "")
        errorRetryButton.setTitle(retryTitle, for: .normal)
    }

    // MARK: Configuration

    /// Add WKWebView to view hierarchy
    ///
    /// - Parameter webView: WKWebView
    func configure(with webView: WKWebView) {
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
    /// - Parameter color: UIColor
    func configure(withThemeColor color: UIColor) {
        loadingIndicator.color = color
        errorRetryButton.backgroundColor = color
    }
}
