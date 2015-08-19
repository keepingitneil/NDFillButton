Pod::Spec.new do |s|
  s.name         = "NDFillButton"
  s.version      = "0.0.9"
  s.summary      = "Button that fills in"

  s.description  = <<-DESC
			Slick button that fills in as the state changes.
                   DESC

  s.homepage     = "https://github.com/keepingitneil/NDFillButton"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author    = "Neil Dwyer"
  s.social_media_url   = "http://twitter.com/dwyer_neil"
  s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/keepingitneil/NDFillButton.git", :tag => "0.0.9" }
  s.source_files  = "NDFillButton/Library", "NDFillButton/Library/**/*.{swift}"
# s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true

end
