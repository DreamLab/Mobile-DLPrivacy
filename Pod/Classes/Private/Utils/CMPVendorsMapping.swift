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
    typealias CMPMapping = (vendorName: String, purposeId: [ConsentPurpose])

    /// AppSDK mapping in CMP system
    static let sdkMapping: [AppSDK: CMPMapping] = [
        .GoogleAdsSDK: CMPMapping(vendorName: "google", purposeId: [.storageAndAccessOfInformation]),
        .GoogleAnalytics: CMPMapping(vendorName: "google", purposeId: [.measurement]),
        .FirebaseAnalytics: CMPMapping(vendorName: "firebase", purposeId: [.measurement]),
        .Gemius: CMPMapping(vendorName: "gemius", purposeId: [.measurement]),
        .Bitplaces: CMPMapping(vendorName: "bitplaces", purposeId: [.adSelectionDeliveryReporting, .measurement]),
        .GoogleConversionTracking: CMPMapping(vendorName: "google", purposeId: [.adSelectionDeliveryReporting, .measurement]),
        .GFK: CMPMapping(vendorName: "gfk", purposeId: [.measurement]),
        .Datarino: CMPMapping(vendorName: "datarino", purposeId: [.personalisation, .adSelectionDeliveryReporting])
    ]
}
