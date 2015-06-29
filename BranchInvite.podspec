Pod::Spec.new do |s|
  s.name         = 'BranchInvite'
  s.version      = '0.3.2'
  s.summary      = 'Invitation functionality for use in conjunction with the Branch iOS SDK'
  s.description  = <<-DESC
- Want the highest possible conversions on your invite feature?
- Want to measure the k-factor of your invite feature?
- Want custom onboarding post install?
- Want it all for free?

Use the Branch SDK (branch.io) to create and power the links that point back to your apps for all of these things and more. Branch makes it incredibly simple to create powerful deep links that can pass data across app install and open while handling all edge cases (using on desktop vs. mobile vs. already having the app installed, etc). Best of all, it's really simple to start using the links for your own app: only 2 lines of code to register the deep link router and one more line of code to create the links with custom data.
                    DESC
  s.homepage     = 'https://branch.io'
  s.screenshots  = "https://s3-us-west-1.amazonaws.com/branch-guides/click_open.gif"
  s.author       = { 'Graham Mueller' => 'graham.mueller315@gmail.com' }
  s.license      = 'Proprietary'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source       = { :git => 'https://github.com/BranchMetrics/Branch-iOS-Invite-SDK.git', :tag => s.version.to_s }
  s.source_files = 'Classes/**/*.{h,m}'

  s.framework = 'AddressBook'
  s.framework = 'MessageUI'

  s.resource_bundles = {
    'BranchInvite' => [ 'Resources/*' ]
  }

  s.dependency 'Branch'
  s.dependency 'HMSegmentedControl', '1.4'
end
