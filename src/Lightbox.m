//
//  LightBox.m
//
//  Created by Roger on 26/08/11.
//  Copyright 2011 LinkOmnia Limited. All rights reserved.
//

#import "Lightbox.h"
#import <QuartzCore/QuartzCore.h>

static const CFTimeInterval _frameDuration = 3.0;
static const CFTimeInterval _transitionDuration = 1.0;
static NSString *_cycleAnimationKey = @"lightbox-cycle-image";

typedef enum {
    kLightboxReady,
    kLightboxPlaying,
    kLightboxWillPause,
    kLightboxPaused,
} LightboxState;

@interface Lightbox () {
@private
    int _currentPage;
    LightboxState _state;
    CFTimeInterval _lastBeginTime;
}
@end

@implementation Lightbox
@synthesize images = _images;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // ...
    }
    return self;
}

- (void)dealloc
{
    [self.layer removeAnimationForKey:_cycleAnimationKey];
    [_images release];
    [super dealloc];
}

- (void)setImages:(NSArray *)images
{
    [self stopAnimating];
    [self.layer removeAnimationForKey:_cycleAnimationKey];
    [_images release];
    _images = images;
    if (_images) {
        [_images retain];
        self.layer.contents = (id)[[UIImage imageNamed:[_images objectAtIndex:0]] CGImage];
        _currentPage = 0;
        _state = kLightboxReady;
    }
}

#define NEXT_PAGE_NUMBER(i) { i++; if (i >= [_images count]) i = 0; }

- (void)cycleImage
{
    if (_state != kLightboxReady && _state != kLightboxPaused) return;

    int nextPage = _currentPage;
    NEXT_PAGE_NUMBER(nextPage);

    CAKeyframeAnimation *a = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    a.duration = _frameDuration + _transitionDuration;
    CGImageRef currentImage = [[UIImage imageNamed:[_images objectAtIndex:_currentPage]] CGImage];
    CGImageRef nextImage = [[UIImage imageNamed:[_images objectAtIndex:nextPage]] CGImage];
    CGFloat ft = _frameDuration / a.duration;
    a.values = [NSArray arrayWithObjects:(id)currentImage, (id)currentImage, (id)nextImage, nil];
    a.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:ft], [NSNumber numberWithFloat:1.0], nil];
    a.calculationMode = kCAAnimationLinear;
    a.fillMode = kCAFillModeForwards;
    a.removedOnCompletion = YES;
    a.delegate = self;

    if (_state == kLightboxPaused) {
        a.beginTime = _lastBeginTime;
    }

    self.layer.contents = (id)nextImage;
    [self.layer addAnimation:a forKey:_cycleAnimationKey];

    _state = kLightboxPlaying;
}

- (void)startAnimating
{
    if (_state == kLightboxPlaying)
        return;
    if (self.layer.speed < 0.1) {
        CFTimeInterval pausedTime = self.layer.timeOffset;
        self.layer.speed = 1.0;
        self.layer.timeOffset = 0.0;
        self.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.layer.beginTime = timeSincePause;
    }
    if (_state == kLightboxWillPause) {
        _state = kLightboxPlaying;
    }
    [self cycleImage];
}

- (void)stopAnimating
{
    if (self.layer.speed > 0.9) {
        CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.layer.speed = 0.0;
        self.layer.timeOffset = pausedTime;
    }
    if (_state == kLightboxPlaying) {
        _state = kLightboxWillPause;
    } else {
        _state = kLightboxReady;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    _lastBeginTime = anim.beginTime;
    if (finished) {
        NEXT_PAGE_NUMBER(_currentPage);
        if  (_state == kLightboxPlaying) {
            _state = kLightboxReady;
            [self cycleImage];
            return;
        }
    }
    _state = kLightboxPaused;
}

@end
