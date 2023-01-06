Pod::Spec.new do |spec|

  spec.name          = "BamboraSDK"
  spec.version       = "0.0.1"
  spec.summary       = <<-DESC
                     This native iOS SDK facilitates handling payments in your apps
                     using the Bambora platform.
                     DESC

  spec.homepage      = "http://EXAMPLE/BamboraSDK"
  spec.license       = { :type => "MIT", :file => "../LICENSE.txt" }
  spec.author        = "Bambora"
  spec.platform      = :ios, "14.0"
  spec.source        = { :git => "https://github.com/bambora/checkout-sdk-ios.git", :tag => spec.version }
  spec.swift_version = "5"
  spec.source_files = "BamboraSDK/*.swift", "BamboraSDK/*/*.swift"
end
