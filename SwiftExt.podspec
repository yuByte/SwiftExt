Pod::Spec.new do |s|
  s.name         = "SwiftExt"
  s.version      = "0.0.2"
  s.summary      = "A library extends Swift standard library"

  s.description  = <<-DESC
                   Swift Extended Library is aiming to offer native Swift alternatives to Cocoa/CocoaTouch and missing conveniences in Swift standard library.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/WeZZard/Swift-Extended-Library"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author	     = { "WeZZard" => "wezzardlau@gmail.com" }
  
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"

  s.source       = { :git => "https://github.com/WeZZard/Swift-Extended-Library.git", :tag => s.version.to_s }

  s.ios.source_files  = "Swift-Extended-Library/**/*.swift", "Swift-Extended-Library-for-iOS/**/*.swift"
  s.osx.source_files  = "Swift-Extended-Library/**/*.swift", "Swift-Extended-Library-for-OS-X/**/*.swift"

  s.requires_arc = true
end
