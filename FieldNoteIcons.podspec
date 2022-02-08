
Pod::Spec.new do |s|
  s.name             = 'FieldNoteIcons'
  s.version          = '1.0.5'
  s.summary          = 'Custom Field Note Icons.'

  s.description      = 'This library supplies custom icons as a UIImage from SVGs with primay color, secondary color, and size attributes'

  s.homepage         = 'https://github.com/TerraSpectrumTechnologies/FieldNoteIcons'
  s.license          = 'Terra Spectrum Technologies'
  s.author           = { 'Matt Hollen' => 'mhollen@terra-spectrum.com' }
  s.source           = { :git => 'git@github.com:TerraSpectrumTechnologies/FieldNoteIcons.git', :tag => '1.0.5' }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files     = 'FieldNoteIcons/**/*'

   s.resource_bundles = {
     'FieldNoteIcons' => ['FieldNoteIcons/Assets/**/*']
   }

   s.dependency 'SVGKit', '~> 3.x'
#    s.dependency 'SVGKit', :git => 'git@github.com:MattHollen/SVGKit.git'
end
