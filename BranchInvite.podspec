Pod::Spec.new do |s|
  s.name         = 'BranchInvite'
  s.version      = '0.1.0'
  s.summary      = 'Invitation functionality for use in conjunction with the Branch iOS SDK'

  s.homepage     = 'https://branch.io'
  s.author       = { 'Graham Mueller' => 'graham.mueller315@gmail.com' }
  s.license      = 'Proprietary'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source       = { :git => 'https://github.com/BranchMetrics/Branch-iOS-Invite-SDK.git', :tag => s.version.to_s }
  s.source_files = 'Classes/*.{h,m}'

  s.framework = 'AddressBook'

  s.resource_bundles = {
    'BranchInvite' => [ 'Resources/*' ]
  }

  s.dependency 'Branch'
  s.dependency 'HMSegmentedControl'
end
