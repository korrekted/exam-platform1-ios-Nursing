platform :ios, ‘13.0’
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'Nursing' do
  pod 'NotificationBannerSwift'
  pod 'lottie-ios'
  pod 'Kingfisher'
  
  pod 'Alamofire'
  
  pod 'RxSwift'
  pod 'RxCocoa'
  
  pod 'SwiftyStoreKit'
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Messaging'
  pod 'Amplitude-iOS'
  pod 'OtterScaleiOS', :git => "https://github.com/AgentChe/OtterScaleiOS.git"
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end

#  pod 'FBSDKCoreKit'
#  pod 'Branch'
#  pod 'AppsFlyerFramework'
