//
//  LightBox.h
//
//  Created by Roger on 26/08/11.
//  Copyright 2011 LinkOmnia Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Lightbox : UIView
@property (nonatomic, retain) NSArray *images;
- (void)startAnimating;
- (void)stopAnimating;
@end
