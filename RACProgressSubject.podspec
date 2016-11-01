#
# Be sure to run `pod lib lint RACProgressSubject.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RACProgressSubject'
  s.version          = '0.18.0'
  s.summary          = 'RACProgressSubject provides an easy way to handle multiple progress signals'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       The objective is to handle the scenarios which involes mutiple progress signals. 
                       For example, when a user wants to login, the app needs to post the login information to the server
                       and download the user infos. In order to display an accurate login progress, we need to handle the
                       progress of both http post and http get operations. 
                       RACProgressSubject can merge the multiple progress signals into single signal.
                       DESC

  s.homepage         = 'https://github.com/haifengkao/RACProgressSubject'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hai Feng Kao' => 'haifeng@cocoaspice.in' }
  s.source           = { :git => 'https://github.com/haifengkao/RACProgressSubject.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RACProgressSubject/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RACProgressSubject' => ['RACProgressSubject/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ReactiveCocoa', '~> 2.0'
end
