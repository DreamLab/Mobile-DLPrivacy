//
//  ConsentPurpose.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 15.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Possible consents purposes
///
/// - storageAndAccessOfInformation: The storage of information, or access to information that is already stored, on your device such
///   as accessing advertising identifiers and/or other device identifiers, and/or using cookies or similar technologies.
/// - personalisation: The collection and processing of information about your use of this site to subsequently personalize advertising
///   for you in other contexts, i.e. on other sites or apps, over time. Typically, the content of the site or app is used to make
///   inferences about your interests which inform future selections.
/// - adSelectionDeliveryReporting: The collection of information, and combination with previously collected information, to select
///   and deliver advertisements for you, and to measure the delivery and effectiveness of such advertisements. This includes using
///   previously collected information about your interests to select ads, processing data about what advertisements were shown,
///   how often they were shown, when and where they were shown, and whether you took any action related to the advertisement,
///   including for example clicking an ad or making a purchase.
/// - contentSelectionDeliveryReporting: The collection of information, and combination with previously collected information,
///   to select and deliver content for you, and to measure the delivery and effectiveness of such content. This includes using
///   previously collected information about your interests to select content, processing data about what content was shown,
///   how often or how long it was shown, when and where it was shown, and whether the you took any action related to the content,
///   including for example clicking on content.
/// - measurement: The collection of information about your use of the content, and combination with previously collected information,
///   used to measure, understand, and report on your usage of the content.
@objc
public enum ConsentPurpose: Int {

    case storageAndAccessOfInformation = 1
    case personalisation = 2
    case adSelectionDeliveryReporting = 3
    case contentSelectionDeliveryReporting = 4
    case measurement = 5
}
