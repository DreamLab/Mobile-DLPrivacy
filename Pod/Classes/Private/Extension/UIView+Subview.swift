//
//  UIView+Subview.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation
import UIKit

// MARK: Subview
extension UIView {

    /// Add given view as subview with full screen constraints
    ///
    /// - Parameters:
    ///   - subview: UIView
    ///   - index: Index at which subview should be inserted
    func addSubviewFullscreen(_ subview: UIView, at index: Int? = nil) {
        subview.translatesAutoresizingMaskIntoConstraints = false

        if let index = index {
            insertSubview(subview, at: index)
        } else {
            addSubview(subview)
        }

        let views = ["subview": subview]
        let hConstrains = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[subview]-(0)-|",
                                                         options: NSLayoutFormatOptions(),
                                                         metrics: nil,
                                                         views: views)
        let vConstrains = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[subview]-(0)-|",
                                                         options: NSLayoutFormatOptions(),
                                                         metrics: nil,
                                                         views: views)
        addConstraints(hConstrains + vConstrains)
    }
}
