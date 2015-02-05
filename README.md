# Branch-iOS-Invite-SDK

The purpose of this SDK is to provide an out-of-the-box functional 'invite feature' for apps consuming the Branch SDK that want to utilize a standard invite feature in their app.

There will still be some configuration on the dashboard, but the goal is to provide the most extensible, yet simple to use, full invite feature SDK. To see the basics of setting up an app with Branch, check out [the Branch iOS SDK readme](https://github.com/BranchMetrics/Branch-iOS-SDK).

# Invite
In your app, there will be a trigger to open the Invite UI. This will show a list of contacts and allow the user to select friends they want to invite to join them.  
![Invite](https://s3-us-west-1.amazonaws.com/branchhost/invite_sdk_1.gif)

# Open
Invited users will receive a message (via SMS, Email, or a custom provider you've implemented). When they open this URL, they'll be fingerprinted by the Branch server as an "invited user," which will be remember when your app is launched on their device.  
![Open](https://s3-us-west-1.amazonaws.com/branchhost/invite_sdk_2.gif)

# Welcome
When Invited Users enter the app, they'll be shown a Welcome UI (either the Branch default, or a custom screen). This Welcome Screen contains the inviting user's image, name, and id. The invited user can choose to accept the invite, or cancel and continue on their own.  
![Welcome](https://s3-us-west-1.amazonaws.com/branchhost/invite_sdk_3.gif)

# Standard Usage
This project is built with, and currently relies on, Cocoapods. To add this project to your app, add the following to your Podfile

```
pod 'BranchInvite'
```

On top of the regular setup for a Branch app, you should add a check within the init callback to check whether the welcome screen should be shown.

```
[[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
    if ([BranchWelcomeViewController shouldShowWelcome:params]) {
        BranchWelcomeViewController *welcomeController = [BranchWelcomeViewController branchWelcomeViewControllerWithDelegate:self branchOpts:params];

        [self.window.rootViewController presentViewController:welcomeController animated:YES completion:NULL];
    }
}];
```

In addition, somewhere in your project you'll need to display the BranchInviteViewController, typically in a menu or somewhere that the user can manually trigger.

```
@implementation ViewController

- (IBAction)inviteButtonPressed:(id)sender {
    id branchInviteViewController = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];

    [self presentViewController:branchInviteViewController animated:YES completion:NULL];
}

@end
```

# Customizations
Both the invite and welcome screens can be customized.

For invitations, beyond just changing the display of the invite controller, you can additonally change the contact providers (the sources of the contacts).

For the welcome screen, you can provide a custom view to be displayed, but it must conform to the specified protocol.

For more detail on both, check out the delegates for both classes.

# Example Usage
The Example folder contains a sample application that utilizes the Branch Invite code. This app contains a basic running example of how the process works, as well as how to customize it.

Note that the customizations are commented out by default -- you'll need to uncomment them to see the view customizations.

To run this project, you'll need to execute `pod install` from within the Example directory.

To test the full cycle,
* Open the app
* Send yourself an invite (note, you must be in your contact book with an email address or phone number)
* Close the app (kill the app entirely)
* Open the invite link
* Reopen the app (should see the welcome screen)

# Iconography
User icon taken from icons8.com
