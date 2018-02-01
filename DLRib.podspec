Pod::Spec.new do |s|
s.name         = "DLRib"
s.version      = "4.0"
s.homepage     = "http://stash.grupa.onet/projects/MB/repos/ios-rib"
s.summary      = "Root project for other PODs to be forked."
s.license      = { :type => 'Copyright. DreamLab', :file => 'LICENSE' }
s.authors      = { "Konrad Falkowski" => "konrad.falkowski@dreamlab.pl" }
s.platform     = :ios, '9.0'
s.source       = { :git => "ssh://git@stash.grupa.onet:7999/mb/ios-rib.git", :tag => s.version }
s.source_files = 'Pod/Classes/**/*.swift'
s.requires_arc = true

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end
