Pod::Spec.new do |s|
  s.name             = 'KSOFileMagic'
  s.version          = '1.0.0'
  s.summary          = 'KSOFileMagic is a iOS/macOS framework that wraps the Darwin file command, which can determine file type by examining file contents.'

  s.description      = <<-DESC
  KSOFileMagic is a iOS/macOS wrapper around the Darwin file command, which can identify files by examing their contents. This can be used to identify a file without a file extension or raw data from the network when a MIME type is not provided. It prefers to use the UTType family of functions to determine types, but will examine the file contents directly if a file extension is not provided or when examining NSData instances.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOFileMagic'
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOFileMagic.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  
  s.requires_arc = true

  s.source_files = 'KSOFileMagic/*.{h,m}', 'KSOFileMagic/Private/*.{h,m}', 'KSOFileMagic/Private/file/config.h', 'KSOFileMagic/Private/file/src/*.{h,c}'
  s.exclude_files = 'KSOFileMagic/KSOFileMagic-Info.h', 'KSOFileMagic/Private/file/src/strlcat.c', 'KSOFileMagic/Private/file/src/strlcpy.c'
  s.private_header_files = 'KSOFileMagic/Private/*.h', 'KSOFileMagic/Private/file/**/*.h'
  
  s.resource_bundles = {
    'KSOFileMagic' => ['KSOFileMagic/Private/file/magic/magic.mgc']
  }

  s.ios.frameworks = 'Foundation', 'MobileCoreServices'
  s.osx.frameworks = 'Foundation'
  
  s.libraries = 'z'
  
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) HAVE_CONFIG_H=1' }
  
  s.dependency 'Stanley'
end
