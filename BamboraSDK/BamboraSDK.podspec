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
  spec.source        = {
        :path => '.',
        :submodules => true
  }
  spec.swift_version = "5"
  spec.dependency 'JOSESwift', '1.8.1'
  spec.dependency 'IOSSecuritySuite', '1.9.1'
  spec.dependency 'ECDHESSwift', '0.0.4'
  spec.dependency 'ASN1Decoder', '1.8.0'
  spec.source_files = "BamboraSDK/*.swift"
end
