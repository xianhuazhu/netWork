//
//  QYBTCentralVC.m
//  01-CoreBluetoothDemo
//
//  Created by qingyun on 15/12/22.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYBTCentralVC.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "QYTransfer.h"

@interface QYBTCentralVC () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *scanSwitch;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;

@property (nonatomic, strong) NSMutableData *data;

@end

@implementation QYBTCentralVC

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建central manager对象
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

#pragma mark - setters & getters 
- (NSMutableData *)data {
    if (_data == nil) {
        _data = [NSMutableData data];
    }
    return _data;
}

#pragma mark - CBCentralManagerDelegate
/**
 *  当Central设备的状态改变之后的回调，当_centralManger对象创建时，也会调该方法 
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"[INFO]: 蓝牙未开启!");
        return;
    }
}

/**
 *  当Central设备发现Peripheral设备发出的AD报文时，调用该方法
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    // 如果，已经发现过该设备，则直接返回；否则，保存该设备，并开始连接该设备
    if (self.discoveredPeripheral == peripheral) {
        return;
    }
    
    NSLog(@"[INFO]: 发现Peripheral设备 <%@> - <%@>", peripheral.name, RSSI);
    
    self.discoveredPeripheral = peripheral;
    
    peripheral.delegate = self;
    
    [self.centralManager connectPeripheral:peripheral options:0];
}

/**
 *  当Central设备连接Peripheral设备失败时的回调
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"[ERROR]: 连接 %@ 失败! (%@)", peripheral, error);
}

/**
 *  当Central设备跟Peripheral设备连接成功之后的回调
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    // 一旦连接成功，就立刻停止扫描
    [self.centralManager stopScan];
    NSLog(@"[INFO]: 正在停止扫描...");
    
    // 清空已经存储的数据，为了重新接收数据
    self.data.length = 0;
    
    // 发现服务 - 根据UUID，去发现我们感兴趣的服务
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    if (error) {
        NSLog(@"[ERROR]: 断开连接失败! (%@)", error);
        [self cleanup];
        return;
    }
    NSLog(@"[INFO]: 连接已断开!");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _scanSwitch.on = NO;
    });
    
    self.discoveredPeripheral = nil;
}

#pragma mark - CBPeripheralDelegate
/**
 *  发现Services之后的回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"[ERROR]: Peripheral设备发现服务(Services)失败! (%@)", error);
        [self cleanup];
        return;
    }
    
    // 遍历Peripheral设备的所有的服务(Services)，去发现我们需要的Characteristics
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}

/**
 *  发现Characteristics之后的回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"[ERROR]: Peripheral设备发现特性(Characteristics)失败! (%@)", error);
        [self cleanup];
        return;
    }
    
    // 遍历该Service的所有Characteristics，然后去订阅这些Characteristics
    for (CBCharacteristic *characteristic in service.characteristics) {
        // 订阅该Characteristic
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

/**
 *  收到数据更新之后的回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"[ERROR]: 更新数据失败! (%@)", error);
        [self cleanup];
        return;
    }
    
    // 取出数据
    NSData *data = characteristic.value;
    
    // 解析数据
    [self parseData:data withPeripheral:peripheral andCharacteristic:characteristic];
}

/**
 *  订阅状态发生变化时的回调
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"[ERROR]: setNotifyValue:forCharacteristic: 失败! (%@)", error);
        [self cleanup];
        return;
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"[INFO]: 已经订阅 %@", characteristic);
    } else {
        NSLog(@"[INFO]: 取消订阅 %@", characteristic);
    }
}

#pragma mark - misc process 
- (void)cleanup {
    if (self.discoveredPeripheral.state != CBPeripheralStateConnected) {
        return;
    }
    
    // 遍历所有服务(Services)的特性(Characteristics)，并且取消订阅
    if (self.discoveredPeripheral.services) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                    }
                }
            }
        }
    }
    
    // 断开Central与Peripheral设备之间的连接
}

- (void)parseData:(NSData *)data withPeripheral:(CBPeripheral *)peripheral andCharacteristic:(CBCharacteristic *)characteristic {
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"[DEBUG]: 已收到 - %@", dataStr);

    // 接收数据完毕 - EOM (End Of Message)
    if ([dataStr isEqualToString:EOM]) {
        // 更新UI
        _textView.text = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        
        // 取消订阅
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // 断开连接
        [self.centralManager cancelPeripheralConnection:peripheral];
        
        return;
    }
    
    // 拼接数据
    [self.data appendData:data];
}

#pragma mark - events handling
- (IBAction)toggleScan:(UISwitch *)sender {
    if (sender.on) {
        // scan
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:0];
        NSLog(@"[INFO]: 开始扫描...");
    } else {
        // stop scan
        [self.centralManager stopScan];
    }
}



@end
