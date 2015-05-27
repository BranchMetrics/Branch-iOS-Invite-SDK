//
//  BranchWelcomeDefaultView.h
//  Pods
//
//  Created by Graham Mueller on 4/16/15.
//
//

#import <UIKit/UIKit.h>
#import "BranchWelcomeView.h"
#import "BranchWelcomeControllerDelegate.h"

@interface BranchWelcomeDefaultView : UIView <BranchWelcomeView>

@property (weak, nonatomic) id <BranchWelcomeControllerDelegate> delegate;

@end
