#
# Be sure to run `pod lib lint Moisture.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Moisture'
  s.version          = '0.1.002'
  s.summary          = 'Personal base library supporting Swift syntax.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/marst123/Moisture'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'marst123' => 'tianlan2325@qq.com' }
  s.source           = { :git => 'https://github.com/marst123/Moisture.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_versions = ['5.0']
  
  s.ios.deployment_target = '13.0'

  # 默认导入 Core 模块
  s.default_subspec = 'Common'
  
  # 主模块的独立文件
#  s.source_files = 'Moisture/Classes/**/*'  # 匹配 unimp 目录下的所有 Swift 文件
  
  s.subspec 'Common' do |common|
    common.source_files = 'Moisture/Classes/Common/**/*'
  end
  
  s.subspec 'Rx' do |rx|
    rx.source_files = 'Moisture/Classes/Rx/**/*'
    rx.dependency 'Moisture/Common'
    rx.dependency 'RxCocoa'
    rx.dependency 'RxSwift'
    rx.dependency 'RxGesture'
    rx.dependency 'RxDataSources'
  end
  
  
  # s.resource_bundles = {
  #   'Moisture' => ['Moisture/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
