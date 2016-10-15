Pod::Spec.new do |s|
  version = "0.0.1"
  s.name         = "HCPermissions"
  s.version      = version
  s.summary      = "Functional permissions access management."
  s.homepage     = "https://github.com/hcrub/HCPermissions"
  s.author       = { "Neil Burchfield" => "neil.burchfield@gmail.com" }
  s.source       = { :git => "git", :tag => version }
  s.platform     = :ios, '8.0'
  s.source_files = 'HCPermissions/*.{h,m}'
  s.requires_arc = true
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.dependency  'ReactiveCocoa', '2.5'
end