//
//  ConfigReader+Custom.swift
//  DLRib
//
//  Created by Konrad Falkowski on 17/03/16.
//  Copyright © 2016 DreamLab. All rights reserved.
//

import UIKit
import DLConfigReader

//This is start point. To be changed when necessary. Example of implementation of ConfigName protocol
enum ConfigItem: String, ConfigName {
    case item1 = "Item1"
    case item2 = "Item2"
    case item3 = "Item3"
}

// Usage of the Config reader.
// Extend it and add customized methods that use getConfig and use them in code as fasade.
extension ConfigReader {

    /// A config value. To be changed when necessary.
    ///
    /// - Returns: value assign to the key in config
    func someConfigValue() -> String {
        return getConfig(ConfigItem.item1, "Key1", String.self)
    }
}
