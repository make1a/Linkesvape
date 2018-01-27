//
//  HNBLEConnectManager.m
//  Linkesvape
//
//  Created by make on 2018/1/5.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNBLEConnectManager.h"
#import "NSTimer+MKTimer.h"
NSString *const filterConditionName =  @"linkedvape";
NSString *const kNotificationBleStatePoweredOn = @"kNotificationBleStatePoweredOn";
NSString *const kNotificationBleStatePoweredOff = @"kNotificationBleStatePoweredOff";
NSString *const kDeviceServiceUUID = @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
NSString *const kDeviceCharacteristicsWrite = @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
NSString *const kDeviceCharacteristicsRead = @"";
NSString *const kDeviceCharacteristicsNotify = @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
NSString *const kNotificationConnectDeviceOutTime = @"kNotificationConnectDeviceOutTime";


@interface HNBLEConnectManager()
{
    int connectNumber;
}
@property (nonatomic,strong)CBCharacteristic * characteristicRead;
@property (nonatomic,strong)CBCharacteristic * characteristicWrite;
@property (nonatomic,strong)CBCharacteristic * characteristicNotify;
@property (nonatomic,strong,readwrite)HNBleDeviceModel * currentDevice;
@property (nonatomic,strong,readwrite)NSMutableArray * deviceList;

//按照mac地址连接设备的定时器
@property (nonatomic,strong)NSTimer * connectWithMacTimer;

@property (nonatomic,assign)BOOL isOTA;


@property (nonatomic,copy,readwrite)NSString *softVersion;

@property (nonatomic,strong)CBCharacteristic *softVersionCharacteristic;

@end

@implementation HNBLEConnectManager

+ (HNBLEConnectManager *)shareInstance{
    static HNBLEConnectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HNBLEConnectManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self babyDelegate];
    }
    return self;
}

- (void)initData{
    self.baby = [BabyBluetooth shareBabyBluetooth];
}

- (void)scan{
    self.baby.scanForPeripherals().begin();
    [self.deviceList removeAllObjects];
}

- (void)connectDevice:(CBPeripheral *)peripheral{
    
    self.baby.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics().begin();
    [self.baby AutoReconnect:peripheral]; //自动重连
}

//手动断开连接
- (void)cancelPeripheral:(CBPeripheral *)peripheral{
    [self.baby cancelPeripheralConnection:peripheral];
    [self.baby AutoReconnectCancel:peripheral]; //删除自动重连
}

- (void)stopScan{
    [self.baby cancelScan];
}

//断开所有peripheral的连接
- (void)cancelAllperipheral{
    [self.baby cancelAllPeripheralsConnection];
}

//根据mac地址去连接已经搜到的设备
- (void)connectDeviceWithMacAddress:(NSString *)mac andOutTimer:(NSInteger)outTime{

    [self scan];
    
    connectNumber = 0;
    if (!self.connectWithMacTimer) {
        self.connectWithMacTimer = [NSTimer mk_scheduledTimerWithTimeInterval:1.f repeats:YES block:^{
            _weakself;
            if (connectNumber == outTime) {
                [weakself.connectWithMacTimer invalidate];
                weakself.connectWithMacTimer = nil;
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationConnectDeviceOutTime object:nil];
            }
            
            connectNumber ++;
            for (HNBleDeviceModel *model in weakself.deviceList) {
                if ([model.macAddress isEqualToString:mac]) {
                    [weakself connectDevice:model.peripheral];
                    connectNumber = 0;
                    [weakself.connectWithMacTimer invalidate];
                    weakself.connectWithMacTimer = nil;
                    break;
                }
            }
        }];
    }else{
        [self.connectWithMacTimer invalidate];
        self.connectWithMacTimer  = nil;
    }
    
}

- (void)connectWithOTA{
    self.isOTA = YES;
    [self stopScan];
    [self scan];
}

- (void)babyDelegate{
    _weakself;
    
    //设备状态改变的委托
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        switch (central.state) {
            case CBCentralManagerStatePoweredOn: //蓝牙打开
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationBleStatePoweredOn object:nil];
                [weakself scan];
            }
                break;
            case CBCentralManagerStatePoweredOff: //蓝牙关闭
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationBleStatePoweredOff object:nil];
            }
            default:
                break;
        }
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [self.baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        DLog(@"peripheralName====%@",peripheralName);
        
        if (self.isOTA == YES) {
            if ([peripheralName isEqualToString:@"EDVAPE_DFU"]) {
                DLog(@"kCBAdvDataManufacturerData===%@",advertisementData);
                return YES;
            }
        }

        
        NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
        if (data.length >= 26) {
            
           NSString *name = [NSString ascilNumberToString:[NSString convertDataToHexStr:[data subdataWithRange:NSMakeRange(9, 17)]]];
            
            if ([name containsString:filterConditionName]) {
                return YES;
            }
        }
        return NO;
    }];
    
    //设置扫描到设备的委托
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
//        DLog(@"搜索到了设备:%@",peripheral);
        DLog(@"ader ======== %@",advertisementData);
        
        if (weakself.isOTA == YES) {
            //OTA模式
            if ([advertisementData[@"kCBAdvDataLocalName"] isEqualToString:@"EDVAPE_DFU"]) {
                weakself.isOTA = NO;
//                [weakself connectDevice:peripheral];
                [weakself stopScan];
                weakself.baby.having(peripheral).connectToPeripherals().begin();
                DLog(@"*******************正在连接OTA模式下的设备*************************");
                return ;
            }
        }

        
        if (![weakself isContain:peripheral]) {
            NSData *data = advertisementData[@"kCBAdvDataManufacturerData"];
            HNBleDeviceModel *device = [[HNBleDeviceModel alloc]initWithData:data];
            device.name = advertisementData[@"kCBAdvDataLocalName"];
            device.peripheral = peripheral;
            //加入设备列表
            [weakself.deviceList addObject:device];
            
            //发现设备回调
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(foundNewDevice:central:advertisementData:)]) {
                [weakself.delegate foundNewDevice:peripheral central:central advertisementData:advertisementData];
            }
        }
    }];
    
    [self.baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if ([peripheralName hasPrefix:filterConditionName] || [advertisementData[@"kCBAdvDataLocalName"] isEqualToString:@"EDVAPE_DFU"]) {
            return YES;
        }
        return NO;
    }];
    
    //连接成功
    [self.baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        
        DLog(@"~~~~~~~~~~~~~ 连接成功 ~~~~~~~~~~~~~~~~~~\n%@",peripheral);
        if ([peripheral.name isEqualToString:@"EDVAPE_DFU"]) { //OTA
            
        }else{
            for (HNBleDeviceModel *model in weakself.deviceList) {
                if ([model.peripheral isEqual:peripheral]) {
                    weakself.currentDevice = model;
                }
            }
        }
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(connectDeviceSucceed:)]) {
            [weakself.delegate connectDeviceSucceed:peripheral];
        }
    }];
    
    
    //查找到服务
    [self.baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            if ([s.UUID isEqual:[CBUUID UUIDWithString:kDeviceServiceUUID]]) {
                DLog(@"**********发现服务******************");
            }
        }
    }];
    
    
    //设置查找到Characteristics的block
    [self.baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kDeviceServiceUUID]]) {
            DLog(@"**********发现特征******************");
            for (CBCharacteristic *c in service.characteristics) {
                if ([c.UUID isEqual:[CBUUID UUIDWithString:kDeviceCharacteristicsWrite]]) { //写
                    weakself.characteristicWrite = c;
                }
                /*
                 else if ([c.UUID isEqual:[CBUUID UUIDWithString:kDeviceCharacteristicsRead]]) { //读
                 weakself.characteristicRead = c;
                 }
                 */
                else if ([c.UUID isEqual:[CBUUID UUIDWithString:kDeviceCharacteristicsNotify]]) { //监听
                    weakself.characteristicNotify = c;
                    [peripheral readValueForCharacteristic:c];
                    [weakself notifyCharacteristic:peripheral];
                }
            }
            
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]){ //设备信息
            
            for (CBCharacteristic *c in service.characteristics) {
                if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                    
                    weakself.softVersionCharacteristic = c;
                    [peripheral readValueForCharacteristic:c];
                    
                 }
            }
            
        }
    }];
    
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        if ([weakself.softVersionCharacteristic isEqual:characteristics]) {
            NSString *softVersion = [NSString ascilNumberToString:[NSString convertDataToHexStr:characteristics.value]];
            weakself.softVersion = softVersion;
        }
    }];
    
    
    //断开连接
    [self.baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        DLog(@"=============断开连接==============");
        DLog(@"error:%@ \n%@",error,error.localizedDescription);
        weakself.currentDevice = nil;
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(disConnectDevice:errro:)]) {
            [weakself.delegate disConnectDevice:peripheral errro:error];
        }
    }];
    
    
    [self.baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        DLog(@"连接失败:%@",error);
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(failToConnectDevice:errro:)]) {
            [weakself.delegate failToConnectDevice:peripheral errro:error];
        }
    }];
    
}




- (void)notifyCharacteristic:(CBPeripheral *)peripheral{
    
    [self.baby notify:peripheral characteristic:self.characteristicNotify block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error){
        DLog(@"***********监听到:characteristic name:%@ value is:%@***********",characteristics.UUID,characteristics.value);
        [HNBLEDataManager receiveData:characteristics.value];
    }];
}



#pragma  mark - 蓝牙读写
- (void)writeValueToDevice:(NSData *)data{
    if (!self.currentDevice.peripheral || !self.characteristicWrite) {
        DLog(@"~~~~~~~~蓝牙都没连上发什么信息?");
        return;
    }
    [self.currentDevice.peripheral writeValue:data forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
}

#pragma  mark - tool
- (BOOL)isContain:(CBPeripheral *)per{
    for (HNBleDeviceModel *model in self.deviceList) {
        if ([model.peripheral isEqual:per]) {
            return YES;
        }
    }
    return NO;
}

#pragma  mark - 懒加载
- (NSMutableArray *)deviceList{
    if (!_deviceList) {
        _deviceList = [@[]mutableCopy];
    }
    return _deviceList;
}



@end
