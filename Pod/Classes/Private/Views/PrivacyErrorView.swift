//
//  PrivacyErrorView.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

/// View displaying error info and retry button
class PrivacyErrorView: UIView {

    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorRetryButton: UIButton!

    /// Proxy for parent view delegate
    weak var delegate: PrivacyFormViewDelegate?

    // MARK: Life cycle

    public override func awakeFromNib() {
        super.awakeFromNib()

        loadTranslations()
    }

    // MARK: Set up

    /// Configure view using theme color, button color and font
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - buttonTextColor: UIColor
    ///   - font: UIFont
    func configure(withThemeColor color: UIColor, buttonTextColor: UIColor, font: UIFont) {
        errorRetryButton.backgroundColor = color
        errorRetryButton.setTitleColor(buttonTextColor, for: .normal)

        errorLabel.font = font.withSize(errorLabel.font.pointSize)

        if let label = errorRetryButton.titleLabel {
            errorRetryButton.titleLabel?.font = font.withSize(label.font.pointSize)
        }
    }

    // MARK: Actions

    @IBAction func onRetryButtonTouch(_ sender: Any) {
        guard let parent = superview as? PrivacyFormView else {
            return
        }

        delegate?.privacyViewRequestingReload(parent)
    }
}

// MARK: Private
private extension PrivacyErrorView {

    /// Load translated texts into view
    func loadTranslations() {
        let bundle = Privacy.resourcesBundle

        errorLabel.text = NSLocalizedString("DLPrivacy.errorView.errorNoInternet", tableName: nil, bundle: bundle, value: "", comment: "")
        let retryTitle = NSLocalizedString("DLPrivacy.errorView.retryButton", tableName: nil, bundle: bundle, value: "", comment: "")
        errorRetryButton.setTitle(retryTitle, for: .normal)
    }
}
