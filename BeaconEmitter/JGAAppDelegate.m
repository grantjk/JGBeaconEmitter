//
//  JGAAppDelegate.m
//  BeaconEmitter
//
//  Created by John Grant on 2014-02-28.
//  Copyright (c) 2014 John Grant. All rights reserved.
//

#import "JGAAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface JGAAppDelegate () <CBPeripheralManagerDelegate>
@property (strong,nonatomic) CBPeripheralManager *peripheralManager;
@end

@implementation JGAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                 queue:nil];
    return YES;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"E132EBAE-AB52-4ABD-B6A8-6B7C65BA407D"];
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                         major:1
                                                                         minor:1000
                                                                    identifier:@"com.blendedcocoa.beacon"];
        
        NSDictionary *proximityData = [region peripheralDataWithMeasuredPower:nil];
        
        
        [peripheral startAdvertising:proximityData];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"Started advertising");
}

@end
