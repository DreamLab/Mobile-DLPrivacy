//
//  DLPrivacy+Bundle.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Resources bundle for module
extension DLPrivacy {

    static var resourcesBundle: Bundle {
        guard let bundlePath = Bundle.main.path(forResource: "DLPrivacy", ofType: "bundle") else {
            return Bundle.main
        }

        return Bundle(path: bundlePath) ?? .main
    }
}
