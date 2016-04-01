source 'https://github.com/CocoaPods/Specs.git'
source 'ssh://git@stash.grupa.onet:7999/pod/dlinternalcocoapods.git'

use_frameworks!
inhibit_all_warnings!

def common_pods
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
end


target 'Backbone' do
	platform :ios, '8.0'
	common_pods
end

target 'BackboneUI' do
    platform :ios, '9.0'
    common_pods
	pod 'DLRemoteControl'
	pod 'DLTestHelpers'
end