Pod::Spec.new do |s|
s.name         = "DLRib"
s.version      = "0.0.1"
s.homepage     = "http://stash.grupa.onet/projects/MB/repos/ios-rib"
s.summary      = "Summary of pod's purpose. To be edited for each pod separately."
s.license      = { :type => 'Copyright. DreamLab', :file => 'LICENSE' }
s.authors      = { "John Doe" => "john.doe@dreamlab.pl" }
s.platform     = :ios, '8.0'
s.source       = { :git => "ssh://git@stash.grupa.onet:7999/mb/ios-rib.git", :tag => s.version }
s.source_files = 'Pod/Classes/*.swift'
s.requires_arc = true
end
