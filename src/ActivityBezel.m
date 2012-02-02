//
//  ActivityBezel.m
//
//  Created by Roger So on 27/02/2011.
//  Copyright 2011 LinkOmnia Limited. All rights reserved.
//

#import "ActivityBezel.h"
#import <QuartzCore/QuartzCore.h>

@implementation ActivityBezel
static id _instance = nil;
@synthesize bezelBackground, activityIndicator, label;

- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark instance methods

- (void)present
{
    [self presentWithMessage:nil];
}

- (void)presentWithMessage:(NSString *)message
{
    if (!bezelBackground) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGSize bezelSize = CGSizeMake(160, 160);

        CGRect frame = CGRectMake((screenSize.width - bezelSize.width)/2, (screenSize.height - bezelSize.height)/2, bezelSize.width, bezelSize.height);
        bezelBackground = [[UIView alloc] initWithFrame:frame];
        bezelBackground.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75];
        bezelBackground.layer.cornerRadius = 20.0f;
    }
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGRect bezelBounds = bezelBackground.bounds;
        activityIndicator.center = CGPointMake(bezelBounds.size.width/2, bezelBounds.size.height/2);
    }
    if (message) {
        if (!label) {
            CGRect labelRect = CGRectMake(20, bezelBackground.bounds.size.height-20-20, bezelBackground.bounds.size.width-40, 20);
            label = [[UILabel alloc] initWithFrame:labelRect];
            [label setTextColor:[UIColor lightTextColor]];
            [label setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]-2]];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
        }
        [label setText:message];
        [bezelBackground addSubview:label];
    } else {
        if (label) {
            [label removeFromSuperview];
            self.label = nil;
        }
    }
    [bezelBackground addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [[[UIApplication sharedApplication] keyWindow] addSubview:bezelBackground];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         if (bezelBackground) bezelBackground.alpha = 0.0f;
                         if (activityIndicator) activityIndicator.alpha = 0.0f;
                         if (bezelBackground) label.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         if (bezelBackground) {
                             [bezelBackground removeFromSuperview];
                         }
                     }];
    self.label = nil;
    self.activityIndicator = nil;
    self.bezelBackground = nil;
}

#pragma mark -
#pragma mark Singleton methods

+ (id)sharedBezel
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ActivityBezel alloc] init];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    // do nothing
}

- (id)autorelease
{
    return self;
}

@end
