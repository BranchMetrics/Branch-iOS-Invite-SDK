Branch iOS Invite SDK change log

- v0.3.11
  * Updated project to Xcode 9.
  * Updated xibs for Xcode 9.
  * Fixed code warnings for Xcode 9.
  * Fixed a problem where UI was updated from the wrong thread.

- v0.3.8
  * fix crash on iPad flavor of devices.

- v0.3.7
  * didn't check in fix before submitting. busy friday, apologies.

- v0.3.6
  * fixed leak
  * submission mistake on 0.3.5

- v0.3.5
  * updated project file to latest format
  * updated to latest HMSegmentedView and fixed obsolete calls
  * fixed warnings in sample app

- v0.3.4
  * Revert 0.3.3.
  * Add ability to customize welcome screen "continue" button font.
  * Fix several imports to work with Cocoapods + Swift + use_frameworks.

- v0.3.3 Bumped HMSegmentedControl version.

- v0.3.2 Making sure constants are in line with the iOS SDK.

- v0.3.1
  * Added ability to specify fonts.
  * Welcome Controller will not consider itself as "should show" if user is already identified.

- v0.3.0
  * Added sharing content classes.

- v0.2.0
  * Adding referral items making it super easy to manage referrals within your app.
  * Updating invite controller to create use the `getReferralUrlWithParams` feature from the Branch SDK.
  * Adding a bunch of sanity checks around delegate items in the invite controller.
  * Adding a ChangeLog.
