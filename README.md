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

Branch must be started within your app before any calls can be made to the SDK.  
  
On top of the regular setup for a Branch app, you should add a check within the init callback to check whether the welcome screen should be shown. By default, the BranchWelcomeViewController will determine this based on keys in the Branch initialization dictionary.  

If you want to implement a custom welcome controller flow entirely, you can check for the invite parameters with the keys provided in the BranchInvite.h file:

```
    BRANCH_INVITE_USER_ID_KEY
    BRANCH_INVITE_USER_FULLNAME_KEY
    BRANCH_INVITE_USER_SHORT_NAME_KEY
    BRANCH_INVITE_USER_IMAGE_URL_KEY
```

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

```objc
@implementation ViewController

- (IBAction)inviteButtonPressed:(id)sender {
    id branchInviteViewController = [BranchInviteViewController branchInviteViewControllerWithDelegate:self];

    [self presentViewController:branchInviteViewController animated:YES completion:NULL];
}

@end
```

## 3. Customizations
Both the invite and welcome screens can be customized.

#### Invitation Customization
The InvitiationControllerDelegate protocol has a number of items that allow you to customize the experience

###### User Info
There are currently four bits of user info that are configurable, two of which are optional.

* User ID  
An identifier for the user, which can be used by the app to tie back to an actual user record in their system. This field is required.

* User Fullname  
The full name of the inviting user, which is displayed in the welcome screen. This is required.

* User Short Name  
A short name for the inviting user, typically their first name. Optional, but recommended.

* User Image Url  
A url to load the inviting user's image from, shown on the Welcome screen. Optional, but recommended.

* Custom Url Data  
The BranchInvite will create a pretty generic Branch short url. This hook allows you to provide any additional data you desire.

###### Invite Display
We've designed the invite screen to be attractive and intuitive, at least in our opinion. You may feel differently, but don't worry -- we provide hooks for you to customize the appearance.

* Segmented Control  
We utilize an HMSegmentedControl to list out the contact providers. One of the hooks allows you to customize the segmented control however you like. Note, however, that any events you add, or segments you provide in this configuration method will be removed.

* TableViewCell Customization
If you're prefer a different appearance to the contact rows, you have two options. You can either provide a custom class which will be registered with the table, or more extensively, a nib (with a class). Either of these classes *must* conform to the BranchInviteContactCell protocol.

###### Advanced: Creating Your Own Contact Providers
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

## 4. Example Usage
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
