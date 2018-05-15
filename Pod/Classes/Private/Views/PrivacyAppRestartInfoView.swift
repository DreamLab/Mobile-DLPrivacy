//
//  PrivacyAppRestartInfoView.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

/// View with text explaining that privacy changes will be applied after app restart
class PrivacyAppRestartInfoView: UIView {

    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var confirmationButton: UIButton!

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
        confirmationButton.backgroundColor = color
        confirmationButton.setTitleColor(buttonTextColor, for: .normal)

        infoLabel.font = font.withSize(infoLabel.font.pointSize)

        if let label = confirmationButton.titleLabel {
            confirmationButton.titleLabel?.font = font.withSize(label.font.pointSize)
        }
    }
}

// MARK: Private
private extension PrivacyAppRestartInfoView {

    // MARK: Actions

    @IBAction func onConfirmationButtonTouch(_ sender: Any) {
        guard let parent = superview as? PrivacyFormView else {
            return
        }

        delegate?.privacyViewRequestingClose(parent)
    }

    // MARK: Translations

    /// Load translated texts into view
    func loadTranslations() {
        let bundle = Privacy.resourcesBundle

        infoLabel.text = NSLocalizedString("DLPrivacy.appRestartView.text", tableName: nil, bundle: bundle, value: "", comment: "")
        let buttonText = NSLocalizedString("DLPrivacy.appRestartView.button", tableName: nil, bundle: bundle, value: "", comment: "")
        confirmationButton.setTitle(buttonText, for: .normal)
    }
}
