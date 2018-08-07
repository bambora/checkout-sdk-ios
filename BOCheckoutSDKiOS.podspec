Pod::Spec.new do |spec|
  spec.name             = 'BOCheckoutSDKiOS'
  spec.version          = '1.0.0'
  spec.summary          = 'The Checkout SDK from Bambora makes it simple to accept payments in your app.'
  spec.homepage         = 'https://developer.bambora.com'
  spec.license          = { :type => "MIT", :file => "LICENSE" }
  spec.author           = { 'Bambora Online' => 'support@bambora.com' }
  spec.source           = { :git => 'https://github.com/bambora/checkout-sdk-ios.git', :tag => spec.version.to_s }
  spec.swift_version    = '4.0'
  spec.platform         = :ios, '9.0'
  spec.source_files     = 'BOCheckoutSDKiOS/**/*.{swift}'
  spec.ios.framework    = 'UIKit'
end
