Pod::Spec.new do |s|
  s.name         = "SwiftExt"
  s.version      = "2.0.0"
  s.summary      = "A library extends Swift standard library"
  
  s.description  = <<-DESC
                   Swift Extended Library is aiming to offer native Swift alternatives to Cocoa/CocoaTouch and missing conveniences in Swift standard library.
                   DESC
  
  s.homepage     = "https://github.com/WeZZard/Swift-Extended-Library"
  
  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author	     = { "WeZZard" => "wezzardlau@gmail.com" }
  
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  
  s.source       = { :git => "https://github.com/WeZZard/Swift-Extended-Library.git", :tag => s.version.to_s }
  
  s.ios.source_files  = "Swift-Extended-Library/**/*.swift", "Swift-Extended-Library-for-iOS/**/*.swift"
  s.osx.source_files  = "Swift-Extended-Library/**/*.swift", "Swift-Extended-Library-for-OS-X/**/*.swift"
end
