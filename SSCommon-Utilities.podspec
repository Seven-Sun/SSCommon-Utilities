Pod::Spec.new do |s|
  s.name         = "SSCommon-Utilities"
  s.version      = "0.0.1"
  s.summary      = "Common lib"

  s.description  = <<-DESC
                   A longer description of SSCommon-Utilities in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://github.com/Seven-Sun/SSCommon-Utilities"
  s.license      = "MIT"
  s.author             = { "SevenChan" => "sun.chao@allgateways.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/Seven-Sun/SSCommon-Utilities.git", :tag => "0.0.1" }

  s.source_files  = 'SSCommon/*.{h,m}'
  s.framework = 'UIKit'
  s.requires_arc = true 
end
