#
# Be sure to run `pod lib lint FNKGraphs.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FNKGraphs"
  s.version          = "0.2.19"
  s.summary          = "A library to make graphing easier"
  s.description      = <<-DESC
                       Graphing on iOS isn't simple. We wanted to help with that. This pod will give you some tools to make a simple line graph. In the future we hope add more types of graphs!
                       DESC
  s.homepage         = "https://github.com/FitnessKeeper/FNKGraphs"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Phillip Connaughton" => "phillip.connaughton@runkeeper.com" }
  s.source           = { :git => "https://github.com/FitnessKeeper/FNKGraphs.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'FNKGraphs' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
