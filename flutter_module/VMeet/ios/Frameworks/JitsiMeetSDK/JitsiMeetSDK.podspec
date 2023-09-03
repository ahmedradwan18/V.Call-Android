Pod::Spec.new do |s|
    s.name             = 'JitsiMeetSDK'
    s.version          = '0.0.1'
    s.summary          = 'V.Meet iOS SDK'
    s.description      = 'V.Meet is a WebRTC compatible, free and Open Source video conferencing system that provides browsers and mobile applications with Real Time Communications capabilities.'
    s.homepage         = 'https://variiance'
    s.license          = 'Apache 2'
    s.authors          = 'The V.Meet project authors'
    s.source           = { :path => 'v_connect/ios/Frameworks/JitsiMeetSDK', :tag => s.version }
    s.platform         = :ios, '12.0'
    s.swift_version    = '5'
    s.vendored_frameworks = 'Frameworks/JitsiMeetSDK.xcframework'
    s.dependency 'Giphy', '2.1.20'
    s.dependency 'JitsiWebRTC'
  end