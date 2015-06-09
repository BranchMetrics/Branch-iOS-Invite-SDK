# Branch-iOS-Invite-SDK

The purpose of this SDK is to provide an out-of-the-box functional 'invite feature' for apps consuming the Branch SDK that want to utilize a standard invite feature in their app.

There will still be some configuration on the dashboard, but the goal is to provide the most extensible, yet simple to use, full invite feature SDK. To see the basics of setting up an app with Branch, check out [the Branch iOS SDK readme](https://github.com/BranchMetrics/Branch-iOS-SDK).

# Invite Flow
In your app, there will be a trigger to open the Invite UI. This will show a list of contacts and allow the user to select friends they want to invite to join them.  

![Invite](https://s3-us-west-1.amazonaws.com/branchhost/invite_sdk_1.gif)

# New User Experience (Install/Open & Personal Welcome)
Invited users will receive a message (via SMS, Email, or a custom provider you've implemented). When they open this URL, they'll be fingerprinted by the Branch server as an "invited user," which will be remember when your app is launched on their device. When Invited Users enter the app, they'll be shown a Welcome UI (either the Branch default, or a custom screen). This Welcome Screen contains the inviting user's image, name, and id. The invited user can choose to accept the invite, or cancel and continue on their own.

![Open](https://s3-us-west-1.amazonaws.com/branch-guides/click_open.gif)

# Usage Guide

* [Branch App Key and Initialization](#1-get-your-branch-app-key-and-sdk-initialization)
* [Setting up Branch in your App](#2-setting-up-branch-in-your-app)
* [Initialization and Showing the Personalized Welcome](#3-initialization-and-showing-the-personalized-welcome)
* [Retrieving Personal Invite Parameters from Session Init](#4-retrieving-invite-parameters-from-session-init)
* [Showing the Invite Controller and Customizations](#5-showing-the-invite-controller-and-customizations)
* [Customization](#6-customizations-and-overrides)
* [Referral Management](#7-referral-management)
* [Sharing Content](#8-sharing-content)
* [Example Usage](#9-example-usage)


## 1. Get your Branch App Key and SDK Initialization

Simply head to [Settings](https://dashboard.branch.io) to create an account to store all of your link data.

## 2. Setting up Branch in your app

### Installing the SDK

BranchInvite can be found on [CocoaPods](http://cocoapods.org). To install it simply add the following line to your Podfile:

```
pod 'BranchInvite'
```

#### Or download the raw files

The Test Bed Project

https://s3-us-west-1.amazonaws.com/branchhost/Branch-iOS-Invite-TestBed.zip

The SDK

https://s3-us-west-1.amazonaws.com/branchhost/Branch-iOS-Invite-SDK.zip

#### Or just clone this project

The base source is found in the **Source With Dependencies** folder of the project.

### Add your app key to your project

After you register your app, your app key can be retrieved on the [Settings](https://dashboard.branch.io/#/settings) page of the dashboard. Now you need to add it to YourProject-Info.plist (Info.plist for Swift).

1. In plist file, mouse hover "Information Property List" which is the root item under the Key column.
1. After about half a second, you will see a "+" sign appear. Click it.
1. In the newly added row, fill in "branch_key" for its key, leave type as String, and enter your app key obtained in above steps in its value column.
1. Save the plist file.

##### Screenshot
![Setting Key in PList Demo](https://s3-us-west-1.amazonaws.com/branch-guides/10_plist.png)

##### Animated Gif
![Setting Key in PList Demo](https://s3-us-west-1.amazonaws.com/branch-guides/9_plist.gif)

### 3. Initialization and Showing the Personalized Welcome

Branch must be started within your app before any calls can be made to the SDK.  
  
On top of the regular setup for a Branch app, you should add a check within the init callback to check whether the welcome screen should be shown. By default, the BranchWelcomeViewController will determine this based on keys in the Branch initialization dictionary.  

Modify the following two methods in your App Delegate:

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
class AppDelegate: UIResponder, UIApplicationDelegate, BranchWelcomeControllerDelegate

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
            let welcomeController: BranchWelcomeViewController = BranchWelcomeViewController(delegate: self, branchOpts: params)
                
            self.window!.rootViewController!.presentViewController(welcomeController, animated: true, completion: nil)
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

## 4. Retrieving Invite Parameters from Session Init

When you call Branch initSession and register the callback, if the user had just clicked an invite link, you can retrieve the individual parameters by using the Branch keys listed below.

```
    BRANCH_INVITE_USER_ID_KEY
    BRANCH_INVITE_USER_FULLNAME_KEY
    BRANCH_INVITE_USER_SHORT_NAME_KEY
    BRANCH_INVITE_USER_IMAGE_URL_KEY
```

## 5. Showing the Invite Controller and Customizations

In addition, somewhere in your project you'll need to display the **BranchInviteViewController**, typically in a menu or somewhere that the user can manually trigger. Here is the code to show the invite controller.

```objc
- (IBAction)inviteButtonPressed:(id)sender {
    id branchInviteViewController = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];

    [self presentViewController:branchInviteViewController animated:YES completion:NULL];
}
```

The view controller that shows the BranchInviteViewController must also implement the **InvitiationControllerDelegate**.

First, to customize the channels that the user will have to invite their friends, you can specify contact providers in an array as below. This example will only show the contacts to be invited via SMS.

```objc
- (NSArray *)inviteContactProviders {
    return @[
        // SMS provider
        [BranchInviteTextContactProvider textContactProviderWithInviteMessageFormat:@"Check out my demo app with Branch:\n\n%@!"]
        
        // Email provider
        //[BranchInviteEmailContactProvider emailContactProviderWithSubject:@"Check out this demo app!" inviteMessageFormat:@"Check out my demo app with Branch:\n\n%@!"],

        // Add your own custom provider
        //[[MysteryIncContactProvider alloc] init]
    ];
}
```

Secondly, you must choose the parameters that will be shown in the personalized welcome to anyone who decides to install from the invite.

```objc

// The full name of the inviting user, which is displayed in the welcome screen. 
// Required
- (NSString *)invitingUserFullname {
    return @"Graham Mueller";
}

// An identifier for the user, which can be used by the app to tie back to an actual user record in you system.
// Optional, but recommended
- (NSString *)invitingUserId {
    return @"shortstuffsushi";
}

// A short name for the inviting user, typically their first name.
// Optional, but recommended
- (NSString *)invitingUserShortName {
    return @"Graham";
}

// A url to load the inviting user's image from, shown on the Welcome screen.
// Optional, but recommended
- (NSString *)invitingUserImageUrl {
    return @"https://www.gravatar.com/avatar/28ed70ee3c8275f1d307d1c5b6eddfa5";
}
```

Lastly, here is where you can customize special parameters that tune the functionality of a Branch link. Below the code snippet is the table of preset keys with the specific type of functionality that they provide

```objc
// The BranchInvite will create a pretty generic Branch short url. 
// This hook allows you to provide any additional data you desire.
- (NSDictionary *)inviteUrlCustomData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:@"Joe's My App Referral" forKey:@"$og_title"];
    [params setObject:@"https://s3-us-west-1.amazonaws.com/myapp/joes_pic.jpg" forKey:@"$og_image_url"];
    [params setObject:@"Join Joe in My App - it's awesome" forKey:@"$og_description"];

    [params setObject:@"http://myapp.com/desktop_splash" forKey:@"$desktop_url"];

    return params;
}
```

**Note**
You can customize the Facebook OG tags of each URL if you want to dynamically share content by using the following _optional keys in the data dictionary_. Please use this [Facebook tool](https://developers.facebook.com/tools/debug/og/object) to debug your OG tags!

| Key | Value
| --- | ---
| "$og_title" | The title you'd like to appear for the link in social media
| "$og_description" | The description you'd like to appear for the link in social media
| "$og_image_url" | The URL for the image you'd like to appear for the link in social media
| "$og_video" | The URL for the video 
| "$og_url" | The URL you'd like to appear
| "$og_app_id" | Your OG app ID. Optional and rarely used.

Also, you do custom redirection by inserting the following _optional keys in the dictionary_:

| Key | Value
| --- | ---
| "$desktop_url" | Where to send the user on a desktop or laptop. By default it is the Branch-hosted text-me service
| "$android_url" | The replacement URL for the Play Store to send the user if they don't have the app. Currently, Chrome does not support this override. _Only necessary if you want a mobile web splash_
| "$ios_url" | The replacement URL for the App Store to send the user if they don't have the app. _Only necessary if you want a mobile web splash_
| "$ipad_url" | Same as above but for iPad Store
| "$fire_url" | Same as above but for Amazon Fire Store
| "$blackberry_url" | Same as above but for Blackberry Store
| "$windows_phone_url" | Same as above but for Windows Store
| "$after_click_url" | When a user returns to the browser after going to the app, take them to this URL. _iOS only; Android coming soon_

You have the ability to control the direct deep linking of each link by inserting the following _optional keys in the dictionary_:

| Key | Value
| --- | ---
| "$deeplink_path" | The value of the deep link path that you'd like us to append to your URI. For example, you could specify "$deeplink_path": "radio/station/456" and we'll open the app with the URI "yourapp://radio/station/456?link_click_id=branch-identifier". This is primarily for supporting legacy deep linking infrastructure. 
| "$always_deeplink" | true or false. (default is not to deep link first) This key can be specified to have our linking service force try to open the app, even if we're not sure the user has the app installed. If the app is not installed, we fall back to the respective app store or $platform_url key. By default, we only open the app if we've seen a user initiate a session in your app from a Branch link (has been cookied and deep linked by Branch)


## 6. Customizations And Overrides
Both the invite and welcome screens can be customized.

#### Invite Display
We've designed the invite screen to be attractive and intuitive, at least in our opinion. You may feel differently, but don't worry -- we provide hooks for you to customize the appearance.

* Segmented Control  
We utilize an HMSegmentedControl to list out the contact providers. One of the hooks allows you to customize the segmented control however you like. Note, however, that any events you add, or segments you provide in this configuration method will be removed.

* TableViewCell Customization
If you're prefer a different appearance to the contact rows, you have two options. You can either provide a custom class which will be registered with the table, or more extensively, a nib (with a class). Either of these classes *must* conform to the BranchInviteContactCell protocol.

#### Creating Your Own Contact Providers
Contact Providers are potentially the biggest point of customization for an app. The default implementation will provides a couple of defaults -- Email and Text -- both of which pull from the Address Book.

Sometimes this isn't enough, though. Perhaps you have a list of contacts from a different 3rd Party system. In that case, you can create your own provider that fulfills the BranchInviteContactProvider protocol. This protocol requires a number of items.

* Tab Title for the Segment Control
* Channel to be used to for the Invite Url
* A Load method for long running loading of contacts
* A method for the Invite screen to retrieve the Contact list
* A method for an error message if contact loading fails
* A method that provides a view controller to be displayed once contacts are selected.

A simple example implementation:
```objc
@interface CustomProvider () <BranchInviteContactProvider>

@property (strong, nonatomic) NSArray *cachedContacts;

@end

@implementation CustomProvider

- (void)loadContactsWithCallback:(callbackWithStatus)callback {
    [self loadSomethingThatTakesALongTime:^(NSArray *retrievedItems) {
        self.cacheItems = retrievedItems;
        callback(YES, nil);
    }
    failure:^(NSError *error) {
        callback(NO, error);
    }];
}

- (NSString *)loadFailureMessage {
    return @"Failed to load custom contacts";
}

// The title of the segment shown in the BranchInviteViewController
- (NSString *)segmentTitle {
    return @"Custom Provider";
}

- (NSString *)channel {
    return @"my_custom_channel";
}

- (NSArray *)contacts {
    return self.cachedContacts;
}

- (UIViewController *)inviteSendingController:(NSArray *)selectedContacts inviteUrl:(NSString *)inviteUrl completionDelegate:(id <BranchInviteSendingCompletionDelegate>)completionDelegate {
    return [CustomerController customControllerWithContacts:selectedContacts inviteUrl:inviteUrl completionDelegate:completionDelegate];
}

@end
```

#### Welcome Customization
For the welcome screen, you can provide a custom view to be displayed, but it must conform to the specified protocol. Otherwise, you can customize the the existing controllers text color and background color.

A simple example implementation:
```objc
@interface CustomerWelcomeScreen () <BranchWelcomeView>

@property (strong, nonatomic) UIButton *customCancelButton;
@property (strong, nonatomic) UIButton *customContinueButton;

@end

@implementation CustomerWelcomeScreen

- (void)configureWithInviteUserInfo:(NSDictionary *)userInviteInfo {
    // Note that this view is created completely programmatically. You could load it from a nib or whatever you like.
    UILabel *userIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 240, 21)];
    userIdLabel.text = [NSString stringWithFormat:@"User ID: %@", userInviteInfo[BRANCH_INVITE_USER_ID_KEY]];
    [self.view addSubview:userIdLabel];

    UILabel *userFullnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 41, 240, 21)];
    userFullnameLabel.text = [NSString stringWithFormat:@"User Fullname: %@", userInviteInfo[BRANCH_INVITE_USER_FULLNAME_KEY]];
    [self.view addSubview:userFullnameLabel];

    UILabel *userShortNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, 240, 21)];
    userShortNameLabel.text = [NSString stringWithFormat:@"User Short Name: %@", userInviteInfo[BRANCH_INVITE_USER_SHORT_NAME_KEY]];
    [self.view addSubview:userShortNameLabel];

    NSString *userImageUrl = userInviteInfo[BRANCH_INVITE_USER_IMAGE_URL_KEY];
    UIImageView *userImageView = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, 64, 64)];
    [self.view addSubview:userImageView];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:userImageUrl]];

        if (!imageData) {
            return;
        }

        UIImage *invitingUserImage = [UIImage imageWithData:imageData];

        dispatch_async(dispatch_get_main_queue(), ^{
            userImageView = invitingUserImage;
        });
    });

    self.customCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.customCancelButton.frame = CGRectMake(20, 200, 50, 32);
    [self.customCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];

    self.customContinueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.customContinueButton.frame = CGRectMake(100, 200, 50, 32);
    [self.customContinueButton setTitle:@"Continue" forState:UIControlStateNormal];
}

- (UIButton *)cancelButton {
    return self.customCancelButton;
}

- (UIButton *)continueButton {
    return self.customContinueButton;
}

@end
```

For more detail on both, check out the delegates for both classes.

## 7. Referral Management
If you're using our referral feature, your users will want to be able to see a few of things:  
  * How many points they've earned.  
  * How many users they have referred.  
  * Some log of the transactions that have contributed to their earnings.
  
The set up for this can be somewhat of a hassle, since you need to do some complicated querying to determine these items. The good news is that we've added that feature to this SDK as well. Adding a referral screen is super simple, and requires only a few lines of set up. The view can easily be displayed modally, or even be dropped into a tab bar set up.

For the default view (no styling) this is as simple as
```
- (void)showMyReferrals {
    BranchReferralController *controller = [BranchReferralController branchReferralControllerWithDelegate:self]
    [self presentViewController:controller animated:YES completion:NULL];
}
```

Of course, as with everything in this SDK, the referral screen is entirely configurable. If the default view isn't to your taste, you can provide your own custom view to the constructor, as long as it conforms to the `BranchReferralView` protocol, which includes three methods you'll want to implement.
```
- (void)setCreditHistoryItems:(NSArray *)creditHistoryItems {
    // this is *all* of the transactions for the user, useful for showing in a list
}

- (void)setReferrals:(NSArray *)referrals {
    // this is the set of transactions that were this user *referring* another user
}

- (void)setControllerDisplayDelegate:(id <BranchReferralViewControllerDisplayDelegate>)displayDelegate {
    // this delegate allows you to dismiss this view when the user is done viewing
}
```

You can find more specific info within each of the header files, or just try out the example app to see working examples.

## 8. Sharing Content
One of the additional features available in the Invite SDK is a simple hook for content sharing. One of the more painful parts of app developement is frequently trying to figure out how to do app routing from within the AppDelegate. The sharing feature allows you to provide a key which, when present in a Branch open dictionary, allows you to show the appropriate screen. As with the other items in the SDK, appearance is totally customizable.

The simplest use case is to just register to default view provided by Branch, though this is quite plain and will likely not match your app's appearance. Note that your AppDelegate should conform the the `BranchSharingControllerDelegate` protocol in order to handle dismissing the content view.
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register for sharing any time the branch options contain the sharing text key
    [BranchSharing registerForSharingEventsWithKey:BRANCH_SHARING_SHARE_TEXT];

    [[Branch getInstance] initSessionWithLaunchOptions:launchOptions isReferrable:YES andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (error) {
            NSLog(@"Init failed: %@", error);
            return;
        }
        
        UIViewController *sharingController = [BranchSharing sharingControllerForBranchOpts:params delegate:self];
        if (sharingController) {
            self.presentingController = self.window.rootViewController;

            [self.presentingController presentViewController:sharingController animated:YES completion:NULL];
        }
    }];
```

You can also provide your own view and/or controller to customize the experience further as well. Note that you *do not* need to use the BRANCH_SHARING_SHARE_TEXT key to register unless you're using the dfeault view. For your own content, you can provide whatever Branch link keys are useful for you!

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register for sharing any time the branch options contain some arbitrary key
    ExampleSharingScreenController *controller = [[ExampleSharingScreenController alloc] initWithNibName:@"ExampleSharingScreen" bundle:[NSBundle mainBundle]];
    [BranchSharing registerForSharingEventsWithKey:@"my_key_indicating_sharing" controller:controller];
    
        [[Branch getInstance] initSessionWithLaunchOptions:launchOptions isReferrable:YES andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (error) {
            NSLog(@"Init failed: %@", error);
            return;
        }
        
        UIViewController *sharingController = [BranchSharing sharingControllerForBranchOpts:params delegate:self];
        if (sharingController) {
            self.presentingController = self.window.rootViewController;

            [self.presentingController presentViewController:sharingController animated:YES completion:NULL];
        }
    }];
```

In this case, your controller would need to conform to the `BranchSharingController` protocol, something like this:
```
@interface ExampleSharingScreenController ()

@property (weak, nonatomic) IBOutlet UILabel *shareTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareImageUrlLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;

@end

@implementation ExampleSharingScreenController

- (void)configureWithSharingData:(NSDictionary *)sharingData {
    NSString *shareText = sharingData[@"my_sharing_text_key"];
    NSString *shareImageUrl = sharingData[@"my_sharing_image_key"];
    
    self.shareTextLabel.text = shareText;
    self.shareImageUrlLabel.text = shareImageUrl;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shareImageView.image = image;
        });
    });
}

@end
```

Check out the Example project for more specific details and example implementations.

## 9. Example Usage
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
A big thanks to [icons8](http://icons8.com) for providing us with a license to use their awesome icons!
