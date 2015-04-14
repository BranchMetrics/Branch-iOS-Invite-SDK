//
//  ReferralTriangleView.m
//  Pods
//
//  Created by Graham Mueller on 4/14/15.
//
//

#import "BranchReferralTriangleView.h"

@implementation BranchReferralTriangleView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextAddLineToPoint(context, rect.size.width / 2.0, rect.size.height);
    CGContextAddLineToPoint(context, 0, 0);
    
    [[UIColor whiteColor] setFill];
    
    CGContextFillPath(context);
}

@end
