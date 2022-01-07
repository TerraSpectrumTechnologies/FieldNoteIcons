
Pod::Spec.new do |s|
  s.name             = 'FieldNoteIcons'
  s.version          = '1.0.0'
  s.summary          = 'A short description of FieldNoteIcons.'

  s.description      = 'Description'

  s.homepage         = 'https://github.com/BreckClone/FieldNoteIcons'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BreckClone' => 'matthollen@gmail.com' }
  s.source           = { :git => 'https://github.com/BreckClone/FieldNoteIcons.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'FieldNoteIcons/**/*'
  
   s.resource_bundles = {
     'FieldNoteIcons' => ['FieldNoteIcons/Assets/**/*']
   }

   s.dependency 'SVGKit', '~> 3.0'
end
