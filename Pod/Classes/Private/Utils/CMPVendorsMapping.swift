//
//  CMPVendorsMapping.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Util class with APPSDK -> (vendor, purposeId) mapping in CMP
class CMPVendorsMapping {

    /// Typealias for CMP vendor name and purpose ids array
    typealias CMPMapping = (vendorName: String, purposeId: [Int])

    /// AppSDK mapping in CMP system
    static let sdkMapping: [AppSDK: CMPMapping] = [
        .GoogleAnalytics: CMPMapping(vendorName: "google", purposeId: [5]),
        .FabricAnswers: CMPMapping(vendorName: "fabric", purposeId: [5]),
        .FirebaseAnalytics: CMPMapping(vendorName: "firebase", purposeId: [5]),
        .FirebaseRemoteConfig: CMPMapping(vendorName: "firebase", purposeId: [4]),
        .Gemius: CMPMapping(vendorName: "gemius", purposeId: [5]),
        .Bitplaces: CMPMapping(vendorName: "bitplaces", purposeId: [3, 5]),
        .GoogleConversionTracking: CMPMapping(vendorName: "google", purposeId: [3, 5])
    ]
}
