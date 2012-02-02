//
//  ActivityBezel.h
//
//  Created by Roger So on 27/02/2011.
//  Copyright 2011 LinkOmnia Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityBezel : NSObject {
    UIView *bezelBackground;
    UIActivityIndicatorView *activityIndicator;
    UILabel *label;
}

@property (nonatomic, retain) UIView *bezelBackground;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *label;

+ (id)sharedBezel;
- (void)present;
- (void)presentWithMessage:(NSString *)message;
- (void)dismiss;

@end
