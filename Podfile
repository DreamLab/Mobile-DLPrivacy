source 'https://github.com/CocoaPods/Specs.git'
source 'ssh://git@stash.grupa.onet:7999/pod/dlinternalcocoapods.git'

platform :ios, '8.0'
use_frameworks!
inhibit_all_warnings!

pod 'ASNotificationCenter'
pod 'DLReachabilityService'
pod 'DLNetworkingService'
pod 'DLMessageBus'
pod 'DLDeviceHelper'
pod 'DLConfigReader'
pod 'DLCocoaLumberjackHelper'
pod 'DLAppHelper'
pod 'DLUIExtensions'
pod 'DLRealmHelpers'
pod 'DLAssetDownloadService'
pod 'Fabric', '~> 1.6.0'
pod 'Crashlytics', '~> 3.5.0'

target 'BackboneUI', :exclusive => true do
    platform :ios, '9.0'
    pod 'DLRemoteControl'
    pod 'DLTestHelpers'
end
