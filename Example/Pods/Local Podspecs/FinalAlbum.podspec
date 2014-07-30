Pod::Spec.new do |s|
  s.name             = "FinalAlbum"
  s.version          = "0.0.1"
  s.summary          = "Ablum for IOS"
  s.homepage         = "https://github.com/loveforgeter/FinalAlbum"
  s.license          = 'MIT'
  s.author           = { "Loveforgeter" => "loveforgeter@gmail.com" }
  s.source           = { :git => "https://github.com/loveforgeter/FinalAlbum.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
end
