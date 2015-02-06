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

# Usage Guide

## 1. Setting up your app on the Branch Dashboard

Our dashboard is the starting point for adding apps as well as tracking users of your app. 

To get started, point your browser to [https://dashboard.branch.io/](https://dashboard.branch.io/). If you haven't created an account before, you can signup and get taken through the basic setup right away. If you've signed up already, simply navigate to the [Summary](https://dashboard.branch.io/#) page and click the dropdown button in the top right. Choose "Create new app."

![Dashboard Screenshot](https://s3-us-west-1.amazonaws.com/branch-guides/2_dashboard.png)

You will be prompted to enter a name for your new app. Do so and press "Create."

![Dashboard Screenshot](https://s3-us-west-1.amazonaws.com/branch-guides/3_create_new_app.png)

Navigate to the Settings page. Scroll down to App Store Information and search for your app by name--this is the same name listed on iTunesConnect. With this information, Branch will automatically redirect users without your app installed on their devices to the App Store.

In the case that your app cannot be found on the App Store (e.g. if you are distributing an enterprise app over the Internet, or you're not listed in the US app stores), you can also enter a custom URL by choosing "Custom URL to IPA file."

![Dashboard Screenshot](https://s3-us-west-1.amazonaws.com/branch-guides/4_settings_app_store.png)

### Customizing the default social media (OG) tags for all links

This optional step will allow you to custom the default tags for all links to your app. While you can edit OG tags when creating links by including the appropriate key-value pairs in the link's data dictionary, it is a good idea to provide a default set of tags that will work for all links.

On the Settings page, scroll to Social Media - Open Graph. 

1. Enter your Facebook App ID (if you have one)
1. Enter the title you want displayed with the link
1. Enter a description of your app (recommended: two sentences)
1. Upload a thumbnail of your app

For more information on the optimal format for the title and description, see Facebook's [Sharing Best Practices](https://developers.facebook.com/docs/sharing/best-practices#tags).

![Dashboard Screenshot](https://s3-us-west-1.amazonaws.com/branch-guides/5_og.png)

### Register a URI scheme direct deep linking (optional but recommended)

You can register your app to respond to direct deep links (yourapp:// in a mobile browser) by adding a URI scheme in the YourProject-Info.plist file (or in Swift, Info.plist).

Also, in the instructions that follow, make sure to change **yourapp** to a unique string that represents your app name. You must choose a string and use the same one on the Branch Dashboard and in XCode.

Before jumping into XCode, you need to add the URI Scheme to the Branch Dashboard. On the [Settings](https://dashboard.branch.io/#/settings) page, scroll down to URI Schemes (advanced), click to expand, and add in the unique string you've chosen for your app (e.g. yourapp://). Be sure to press "Save" when you're finished.

![Dashboard Screenshot](https://s3-us-west-1.amazonaws.com/branch-guides/6_dashboard_uri.png)

Next, you'll need to open your project in XCode and complete the following.

1. Click on YourProject-Info.plist on the left (or in Swift, Info.plist).
1. Find URL Types and click the right arrow. (If it doesn't exist, right click anywhere and choose Add Row. Scroll down and choose URL Types)
1. Add "yourapp", where yourapp is a unique string for your app, as an item in URL Schemes as below:

![URL Scheme Demo](https://s3-us-west-1.amazonaws.com/branchhost/urlScheme.png)

Alternatively, you can add the URI scheme in your project's Info page.

1. In Xcode, click your project in the Navigator (on the left side).
1. Select the "Info" tab.
1. Expand the "URL Types" section at the bottom.
1. Click the "+" sign to add a new URI Scheme, as below:

![URL Scheme Demo](https://s3-us-west-1.amazonaws.com/branchhost/urlType.png)

## 2. Setting up Branch in your app

### Installing the SDK

BranchInvite requires use of [CocoaPods](http://cocoapods.org). To install it simply add the following line to your Podfile:

```
    pod 'Branch'
    pod 'BranchInvite'
```

### Add your app key to your project

After you register your app, your app key can be retrieved on the [Settings](https://dashboard.branch.io/#/settings) page of the dashboard. Now you need to add it to YourProject-Info.plist (Info.plist for Swift).

1. In plist file, mouse hover "Information Property List" which is the root item under the Key column.
1. After about half a second, you will see a "+" sign appear. Click it.
1. In the newly added row, fill in "bnc_app_key" for its key, leave type as String, and enter your app key obtained in above steps in its value column.
1. Save the plist file.

##### Screenshot
![Setting Key in PList Demo](https://s3-us-west-1.amazonaws.com/branch-guides/10_plist.png)

##### Animated Gif
![Setting Key in PList Demo](https://s3-us-west-1.amazonaws.com/branch-guides/9_plist.gif)

Branch must be started within your app before any calls can be made to the SDK. On top of the regular setup for a Branch app, you should add a check within the init callback to check whether the welcome screen should be shown. Modify the following two methods in your App Delegate:

##### Objective-C

```objc
#import <Branch/Branch.h>
#import "BranchWelcomeViewController.h"
```

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // anything else you need to do in this method
    // ...

    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {     // previously initUserSessionWithCallback:withLaunchOptions:
        if (!error) {
            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
            // params will be empty if no data found
            // ... insert custom logic here ...   
        }

        if ([BranchWelcomeViewController shouldShowWelcome:params]) {
            BranchWelcomeViewController *welcomeController = [BranchWelcomeViewController branchWelcomeViewControllerWithDelegate:self branchOpts:params];

            [self.window.rootViewController presentViewController:welcomeController animated:YES completion:NULL];
        }
    }];
}
```

```objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // pass the url to the handle deep link call
    // if handleDeepLink returns YES, and you registered a callback in initSessionAndRegisterDeepLinkHandler, the callback will be called with the data associated with the deep link
    if (![[Branch getInstance] handleDeepLink:url]) {
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
    }
    return YES;
}
```

##### Swift
```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // anything else you need to do in this method
    // ...
    
    let branch: Branch = Branch.getInstance()
    branch.initSessionWithLaunchOptions(launchOptions, andRegisterDeepLinkHandler: { params, error in
        if (error == nil) {
            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
            // params will be empty if no data found
            // ... insert custom logic here ...   
        }

        if (BranchWelcomeViewController.shouldShowWelcome(params)) {
            let welcomeController: BranchWelcomeViewController = BranchWelcomeViewController.branchWelcomeViewControllerWithDelegate(self branchOpts:params);

            self.window.rootViewController.presentViewController(welcomeController animated:YES completion:NULL);
        }
    })
        
    return true
}
```

```swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    // pass the url to the handle deep link call
    // if handleDeepLink returns true, and you registered a callback in initSessionAndRegisterDeepLinkHandler, the callback will be called with the data associated with the deep link
    if (!Branch.getInstance().handleDeepLink(url)) {
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
    }
        
    return true
}
```

The deep link handler is called every single time the app is opened, returning deep link data if the user tapped on a link that led to this app open.

This same code also triggers the recording of an event with Branch. If this is the first time a user has opened the app, an "install" event is registered. Every subsequent time the user opens the app, it will trigger an "open" event.
This project is built with, and currently relies on, Cocoapods. To add this project to your app, add the following to your Podfile

## Showing the Invite Controller

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
