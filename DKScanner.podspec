Pod::Spec.new do |s|
    s.name         = "DKScanner"
    s.version      = "1.1.0"
    s.ios.deployment_target = '8.0'
    s.summary      = "A QRCode Scanner for iOS."
    s.homepage     = "https://github.com/bingozb/DKScanner.git"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "bingozb" => "454113692@qq.com" }
    s.source       = { :git => "https://github.com/bingozb/DKScanner.git", :tag => "v1.1.0" }
    s.source_files  = "DKScanner/*.{h,m}"
    s.resources          = "DKScanner/DKScanner.bundle"
    s.requires_arc = true
end