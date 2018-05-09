//
//  AppSDK.swift
//  DLPrivacy
//
//  Created by Szeremeta Adam on 09.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

import Foundation

/// Available SDK for which we can have consents
///
/// - dfpAds: Googel Ads
/// - googleAnalytics: GoogleAnalytic
/// - fabric: Fabric (Crashylytics & Answers)
/// - instabug: Instabug
/// - branchIO: Branch.io
/// - pushwoosh: PushWoosh
/// - firebase: Firebase (Analytics & Remote Config)
/// - gemius: Gemius
/// - bitplaces: Bitplaces
/// - justWifi: JustWiFi
/// - spiceMobile: SpiceMobile
@objc
public enum AppSDKAA: Int {

    case dfpAds
    case googleAnalytics
    case fabric
    case instabug
    case branchIO
    case pushwoosh
    case firebase
    case gemius
    case bitplaces
    case justWifi
    case spiceMobile

    // TODO: [ASZ] Add enum to name mapping
}


//typedef NSString * TrafficLightColor NS_EXTENSIBLE_STRING_ENUM;

//static TrafficLightColor const TrafficLightColorRed = @"Red";
//static TrafficLightColor const TrafficLightColorYellow = @"Yellow";
//static TrafficLightColor const TrafficLightColorGreen = @"Green";
