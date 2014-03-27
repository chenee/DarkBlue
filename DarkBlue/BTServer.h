//
//  BTServer.h
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "PeriperalInfo.h"

#define UUIDPrimaryService  @"0xFF00"//tmp 0XFFA0 should be 0xFF00
#define UUIDPrimaryService2  @"0xFFA0"//tmp 0XFFA0 should be 0xFF00
#define UUIDDeviceInfo      @"0xFF01"
#define UUIDRealTimeDate    @"0xFF02"
#define UUIDControlPoint    @"0xFF03"
#define UUIDData            @"0xFF04"
#define UUIDFirmwareData    @"0xFF05"
#define UUIDDebugData       @"0xFF06"
#define UUIDBLEUserInfo     @"0xFF07"

#define AUTO_CANCEL_CONNECT_TIMEOUT 10
typedef void (^eventBlock)(CBPeripheral *peripheral, BOOL status, NSError *error);
typedef enum{
    KNOT = 0,
    KING = 1,
    KSUCCESS = 2,
    KFAILED = 3,
}myStatus;

@protocol BTServerDelegate
@optional
-(void)didStopScan;
-(void)didFoundPeripheral;
-(void)didReadvalue;

@required
-(void)didDisconnect;

@end

@interface BTServer : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>
+(BTServer*)defaultBTServer;
@property(weak, nonatomic) id<BTServerDelegate> delegate;

//
@property (strong,nonatomic)NSMutableArray *discoveredPeripherals;
@property (strong,nonatomic)CBPeripheral* selectPeripheral;
@property (strong,nonatomic)CBService* discoveredSevice;
@property (strong,nonatomic)CBCharacteristic *selectCharacteristic;

//@property (strong,nonatomic)NSMutableArray *services;


//
-(void)startScan;
-(void)startScan:(NSInteger)forLastTime;
-(void)stopScan;
-(void)stopScan:(BOOL)withOutEvent;
//-(void)connect:(PeriperalInfo*)peripheralInfo;
-(void)connect:(PeriperalInfo *)peripheralInfo withFinishCB:(eventBlock)callback;
-(void)disConnect;
-(void)discoverService:(CBService*)service;
-(void)readValue:(CBCharacteristic*)characteristic;

//state
-(NSInteger)getConnectState;
-(NSInteger)getServiceState;
-(NSInteger)getCharacteristicState;

@end
