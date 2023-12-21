Pod::Spec.new do |spec|

  spec.name          = "BamboraCheckoutSDK"
  spec.version       = "2.0.3"
  spec.summary       = <<-DESC
                     This native iOS SDK facilitates handling payments in your apps
                     using the Bambora platform.
                     DESC

  spec.homepage      = "https://github.com/bambora/checkout-sdk-ios"
  spec.license       = { :type => "MIT", :file => "LICENSE" }
  spec.author        = "Worldline Bambora"
  spec.platform      = :ios, "15.0"
  spec.module_name   = "BamboraSDK"
  spec.source        = { :git => "https://github.com/bambora/checkout-sdk-ios.git", :tag => spec.version }
  spec.swift_version = "5"
  spec.source_files = "BamboraSDK/BamboraSDK/*.swift", "BamboraSDK/BamboraSDK/Extensions/*.swift"
end
