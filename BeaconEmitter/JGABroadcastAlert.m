//
//  JGABroadcastAlert.m
//  BeaconEmitter
//
//  Created by John Grant on 2014-03-02.
//  Copyright (c) 2014 John Grant. All rights reserved.
//

#import "JGABroadcastAlert.h"

@interface JGABroadcastAlert ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation JGABroadcastAlert

+ (instancetype)broadcastAlert
{
    CGFloat deviceWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    JGABroadcastAlert *alert = [[JGABroadcastAlert alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 64)];
    alert.label.text = NSLocalizedString(@"Broadcasting...", @"BroadcastAlert");
    return alert;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        [self addSubview:self.label];
    }
    return self;
}

- (UILabel *)label
{
    if (!_label) {
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont boldSystemFontOfSize:24];
    }
    return _label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(0, 20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-20);
}

- (void)show
{
    self.alpha = 0;
    CGRect frame = self.frame;
    frame.origin.y = -CGRectGetHeight(frame);
    self.frame = frame;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    CGRect destinationFrame = frame;
    destinationFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = destinationFrame;
        self.alpha = 1.0f;
    }];
}

- (void)hide
{
    CGRect destinationFrame = self.frame;
    destinationFrame.origin.y = -CGRectGetHeight(destinationFrame);

    [UIView animateWithDuration:0.3f animations:^{
        self.frame = destinationFrame;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
