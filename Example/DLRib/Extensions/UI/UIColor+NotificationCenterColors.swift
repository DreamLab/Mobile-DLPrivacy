//
//  UIColor+AppColors.swift
//  DLRib
//
//  Created by Konrad Falkowski on 17/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import UIKit

// MARK: - Custom UIColors for NotificationCenter
extension UIColor {

    /// Notification Center normal background color
    static var notificationNormalBackgroundColor: UIColor {
        return UIColor(red: 0, green: 0.49, blue: 0.79, alpha: 1)
    }

    /// Notification Center positive background color
    static var notificationPositiveBackgroundColor: UIColor {
        return UIColor(red: 0.00, green: 0.59, blue: 0.25, alpha: 1.0)
    }

    /// Notification Center critical background color
    static var notificationCriticalBackgroundColor: UIColor {
        return UIColor(red: 0.89, green: 0.02, blue: 0.07, alpha: 1.0)
    }
}
