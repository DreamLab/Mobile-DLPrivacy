//
//  ASNotificationServiceInitializer.swift
//  Backbone
//
//  Created by Konrad Kierys on 12.01.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import UIKit
import Foundation
import ASNotificationCenter
import DLUIExtensions

/**
Class to initialize ASNotificationCenter
*/
class ASNotificationServiceInitializer {

    /// Time of notification apperance on screen. Worded in seconds.
    static let notificationApperanceTime = 4.0

    /**
    Initialize ASNotificationCenter
    */
    class func initialize() {
        let notificationCenter = ASNotificationCenter.sharedInstance()
        notificationCenter.normalColor = UIColor.notificationNormalBackgroundColor
        notificationCenter.positiveColor = UIColor.notificationPositiveBackgroundColor
        notificationCenter.criticalColor = UIColor.notificationCriticalBackgroundColor
        notificationCenter.notificationApperanceTime = notificationApperanceTime
        notificationCenter.setupNotificationCenter()
    }
}
