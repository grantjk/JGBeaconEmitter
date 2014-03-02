//
//  JGABroadcastController.m
//  BeaconEmitter
//
//  Created by John Grant on 2014-03-02.
//  Copyright (c) 2014 John Grant. All rights reserved.
//

#import "JGABroadcastController.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "JGABroadcastAlert.h"

@interface JGABroadcastController ()  <CBPeripheralManagerDelegate>
@property (strong,nonatomic) CBPeripheralManager *peripheralManager;

@property (nonatomic, assign) NSInteger beaconNumber;
@property (nonatomic, assign) BOOL expectedToBeOn;
@property (nonatomic, strong) JGABroadcastAlert *alert;
@end

@implementation JGABroadcastController

- (id)init
{
    self = [super init];
    if (self) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil];
    }
    
    return self;
}

- (JGABroadcastAlert *)alert
{
    if (!_alert) {
        self.alert = [JGABroadcastAlert broadcastAlert];
    }
    return _alert;
}

- (void)startBroadcastingWithNumber:(NSInteger)beaconNumber
{
    if (!self.peripheralManager.isAdvertising) {
        self.beaconNumber = beaconNumber;
        self.expectedToBeOn = YES;
        
        if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
            [self startBroadcastWithCurrentRegionData];
        }
    }
}
- (void)stopBroadcasting
{
    [self.peripheralManager stopAdvertising];
    self.expectedToBeOn = NO;
    [self.alert hide];
}
- (BOOL)isBroadcasting
{
    return self.peripheralManager.isAdvertising;
}

- (NSDictionary *)promixityInformationForCurrentRegion
{
    if (!self.expectedToBeOn || self.beaconNumber == 0) {
        return nil;
    }

    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"E132EBAE-AB52-4ABD-B6A8-6B7C65BA407D"];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                     major:1
                                                                     minor:self.beaconNumber
                                                                identifier:@"ca.jga.beaconEmitter"];
    return [region peripheralDataWithMeasuredPower:nil];
}

- (void)startBroadcastWithCurrentRegionData
{
    NSDictionary *proximityData = [self promixityInformationForCurrentRegion];
    if (proximityData) {
        [self.peripheralManager startAdvertising:proximityData];
    }
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"didchange state : %d", peripheral.state);
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self startBroadcastWithCurrentRegionData];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    [self.alert show];
    NSLog(@"Started advertising as number: %d", self.beaconNumber);
    if (error) {
        NSLog(@"Error starting: %@", error);
    }
}

@end
