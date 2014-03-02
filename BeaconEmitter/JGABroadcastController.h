//
//  JGABroadcastController.h
//  BeaconEmitter
//
//  Created by John Grant on 2014-03-02.
//  Copyright (c) 2014 John Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGABroadcastController : NSObject

- (void)startBroadcastingWithNumber:(NSInteger)beaconNumber;
- (void)stopBroadcasting;
- (BOOL)isBroadcasting;

@end
