# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HEPI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HEPI
  pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'FirebaseAnalytics'
  pod 'FirebaseCore'
  pod 'FirebaseMLModelDownloader', '9.3.0-beta'
  pod 'TensorFlowLiteTaskText', '~> 0.2.0'

  target 'HEPITests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'HEPIUITests' do
    # Pods for testing
  end

end

post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
          bc.build_settings['ARCHS[sdk=iphonesimulator*]'] =  `uname -m`
       end
   end
end
