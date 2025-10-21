require 'json'

package = JSON.parse(File.read(File.join(__dir__, '..', 'package.json')))

Pod::Spec.new do |s|
  s.name           = 'RocketExpo'
  s.version        = package['version']
  s.summary        = package['description']
  s.description    = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.platforms      = {
    :ios => '15.1',
    :tvos => '15.1'
  }
  s.swift_version  = '5.9'
  s.source         = { git: 'https://github.com/shift72/rocket-expo' }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'

  # Swift/Objective-C compatibility
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }

  s.source_files = "**/*.{h,m,mm,swift,hpp,cpp}"

  if defined?(:spm_dependency)
      spm_dependency(s,
     url: 'https://github.com/shift72/rocket-sdk-ios.git',
     requirement: {kind: 'upToNextMajorVersion', minimumVersion: '0.2.0'},
     products: ['Shift72RocketSDK']
   )   else
    raise "Please upgrade React Native to >=0.75.0 to use SPM dependencies."
  end


end
