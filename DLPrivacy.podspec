Pod::Spec.new do |s|
s.name         = "DLPrivacy"
s.version      = "5.0.100"
s.homepage     = "http://stash.grupa.onet/projects/POD/repos/dlprivacy"
s.summary      = "Library used to gather consents from user."
s.license      = { :type => 'Copyright. DreamLab', :file => 'LICENSE' }
s.authors      = { "Adam Szeremeta" => "adam.szeremeta@dreamlab.pl" }
s.platform     = :ios, '9.0'
s.source       = { :git => "ssh://git@stash.grupa.onet:7999/POD/dlprivacy.git", :tag => s.version }

s.dependency   'CocoaLumberjack/Swift', '~> 3.3.0'

s.source_files = 'Pod/Classes/**/*.swift'
s.resource_bundles  = { 'DLPrivacy' => [
    'Pod/Resources/**/*'
] }

s.swift_version = '4.0'
s.static_framework = true
s.requires_arc = true

end
