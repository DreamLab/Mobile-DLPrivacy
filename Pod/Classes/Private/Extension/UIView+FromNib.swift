//
//  UIView+FromNib.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

// MARK: FromNib
extension UIView {

    /// Return UIView instance loaded from nib
    ///
    /// - Returns: UIView
    static func loadFromNib<T: UIView>() -> T {
        let viewNib = UINib(nibName: "\(T.self)", bundle: Privacy.resourcesBundle)
        let view = viewNib.instantiate(withOwner: self, options: nil).first as? T

        // swiftlint:disable force_unwrapping
        return view!
        // swiftlint:enable force_unwrapping
    }
}
