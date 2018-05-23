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
        .GoogleAdsSDK: CMPMapping(vendorName: "google",
                                  purposeId: [.storageAndAccessOfInformation]),
        .GoogleAnalytics: CMPMapping(vendorName: "google",
                                     purposeId: [.measurement]),
        .FirebaseAnalytics: CMPMapping(vendorName: "firebase",
                                       purposeId: [.storageAndAccessOfInformation,
                                                   .measurement]),
        .Gemius: CMPMapping(vendorName: "gemius",
                            purposeId: [.storageAndAccessOfInformation,
                                        .measurement]),
        .Bitplaces: CMPMapping(vendorName: "bitplaces",
                               purposeId: [.storageAndAccessOfInformation,
                                           .adSelectionDeliveryReporting,
                                           .measurement]),
        .GoogleConversionTracking: CMPMapping(vendorName: "google",
                                              purposeId: [.storageAndAccessOfInformation,
                                                          .adSelectionDeliveryReporting,
                                                          .measurement]),
        .GFK: CMPMapping(vendorName: "gfk",
                         purposeId: [.storageAndAccessOfInformation,
                                     .measurement]),
        .Datarino: CMPMapping(vendorName: "datarino",
                              purposeId: [.storageAndAccessOfInformation,
                                          .personalisation,
                                          .adSelectionDeliveryReporting])
    ]
}
