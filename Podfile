# Uncomment the next line to define a global platform for your project
# platform :ios, ’10.0’

target 'Soomter' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Soomter

    pod 'Alamofire', '~> 4.7'
    pod 'ObjectMapper', '~> 3.3'
    pod 'Cosmos', '~> 16.0'
    pod 'Kingfisher', '~> 4.0'
    pod 'BEMCheckBox'
    pod 'SideMenu'
    pod 'XLPagerTabStrip', '~> 8.0'
    pod 'PagingTableView'
    pod 'ESTabBarController-swift'
    pod 'iOSDropDown'
    pod 'DatePickerDialog'
    pod 'L10n-swift', '~> 5.4'
    pod 'IQKeyboardManagerSwift'
    pod 'JGProgressHUD'


post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
end
