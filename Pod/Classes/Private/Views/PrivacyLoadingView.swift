//
//  PrivacyLoadingView.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

/// Loading view with animated element
class PrivacyLoadingView: UIView {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    // MARK: Set up

    /// Configure loading view with theme color
    ///
    /// - Parameter color: UIColor
    func configure(_ color: UIColor) {
        loadingIndicator.color = color
    }

    // MARK: Animation

    /// Start animation in view
    func startAnimation() {
        loadingIndicator.startAnimating()
    }

    /// Stop animation in view
    func stopAnimation() {
        loadingIndicator.stopAnimating()
    }
}
