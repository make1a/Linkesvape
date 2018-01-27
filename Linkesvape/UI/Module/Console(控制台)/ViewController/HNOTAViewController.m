//
//  HNOTAViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/22.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNOTAViewController.h"
#import "HNOTACell.h"
#import "HNDFUModel.h"
#import "NSTimer+MKTimer.h"
@import iOSDFULibrary;

@interface HNOTAViewController ()<UITableViewDelegate,UITableViewDataSource,LoggerDelegate,DFUProgressDelegate,DFUServiceDelegate,HNBleConnectDelegate>
@property (nonatomic,strong)UILabel * noticeLabel;
@property (nonatomic,strong)UITableView * tableView;

/**发包的总次数 */
@property (nonatomic,assign) NSInteger totalNumber;
@property (nonatomic,assign) NSInteger roundTotalNumber; //轮次总包数

// 当前发包数字
@property (nonatomic,assign)NSInteger currentNumber;
//第几轮
@property (nonatomic,assign)NSInteger currentRoundNumber;
/**发包定时器*/
@property (nonatomic,strong) NSTimer *timer;




//mac地址
@property (nonatomic,copy)NSString * macAddress;

@property (nonatomic,strong)NSTimer * connectDeviceTimer;

@property (nonatomic,assign)BOOL isDeviceUpdate; //主控芯片升级
@property (nonatomic,assign)BOOL isBleUpdate; //固件升级
@property (nonatomic,strong)MBProgressHUD *mbp;

@property (nonatomic,strong)NSURL * filePath;
@end

@implementation HNOTAViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (![HNBLEConnectManager shareInstance].currentDevice) {
//        [self loadAbankViewWithSuperView:self.view frame:self.view.bounds imageStr:@"unconnected_device" descStr:NSLocalizedString(@"需要连接设备才能继续操作哦~", nil)];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectOverTime:) name:kNotificationConnectDeviceOutTime object:nil];
}

- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"控制台", nil)];
}

#pragma  mark - 网络请求
- (void)checkVesion{
    
    _weakself;
    self.mbp.label.text =NSLocalizedString(@"正在获取最新固件", nil);
    [self.mbp showAnimated:YES];
    
    [HNRequestManager downWithFileUrlString:@"http://vape-1255646621.cos.ap-chengdu.myqcloud.com/other/2018012589bb903f0fee228108f4.zip" success:^(id responseObject, NSURL *filePath) {
        
        [MBProgressHUD showSuccess:@"固件信息获取成功"];
        
        self.mbp.label.text =NSLocalizedString(@"正在准备固件升级...", nil);
        [self.mbp showAnimated:YES];
        
        self.filePath = filePath;
        
        weakself.macAddress = [HNDFUModel sendOTACode];
        [weakself connectUpdateDevice];
        
    } faild:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ERROR;
    }];
    
    
    /*

    NSDictionary *dic;
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:GetDeviceVersion requestParameters:dic requestHeader:nil success:^(id responseObject) {

        if (CODE==200) {
            
            NSString *deviceVersion = responseObject[@"d"][@"device_version"][@"version"]; //主控芯片版本号
            
            
            NSString *link_version = responseObject[@"d"][@"link_version"][@"version"]; //固件升级
            //v1.0.0
            
            NSMutableString * linkVersionService = [@"" mutableCopy];
            [linkVersionService appendFormat:@"%@%@%@",[link_version substringWithRange:NSMakeRange(1, 1)],[link_version substringWithRange:NSMakeRange(3, 1)],[link_version substringWithRange:NSMakeRange(5, 1)]];
            
            
            NSMutableString * linkVersionDevice = [@"" mutableCopy];
            [linkVersionDevice appendFormat:@"%@%@%@",[[HNBLEConnectManager shareInstance].softVersion substringWithRange:NSMakeRange(1, 1)],[[HNBLEConnectManager shareInstance].softVersion substringWithRange:NSMakeRange(3, 1)],[[HNBLEConnectManager shareInstance].softVersion substringWithRange:NSMakeRange(5, 1)]];
            
            
            if ([linkVersionDevice integerValue] <[linkVersionService integerValue]) { //升级
                [MBProgressHUD showMessage:NSLocalizedString(@"正在获取最新固件", nil)];
                [HNRequestManager downWithFileUrlString:responseObject[@"d"][@"link_version"][@"version_file"] success:^(id responseObject, NSURL *filePath) {
                    
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"固件信息获取成功"];

                    weakself.macAddress = [HNDFUModel sendOTACode];
                    [weakself connectUpdateDevice];
                    
                } faild:^(NSError *error) {
                    ERROR;
                }];
            }
        }else{
            MBErrorMsg;
        }
        
    } faild:^(NSError *error) {
        ERROR;
    }];
    */
}

- (void)getDeviceVersion{
    
}


#pragma  mark - actions
- (void)connectOverTime:(NSNotification *)noti{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:NSLocalizedString(@"连接超时，检查蓝牙是否打开和设备是否在附近", nil)];
}

- (void)connectUpdateDevice{
    [HNBLEConnectManager shareInstance].delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[HNBLEConnectManager shareInstance]connectWithOTA];
    });
}

- (void)aspectTheUpdateStatus{
    [HNAspectsStore getDeviceUpdateStatus:^(BOOL isSuccess) {
        if (isSuccess == YES) {
            self.currentRoundNumber ++;
            [self updateAction];
        }
    }];
}

- (void)updateAction{
    
    NSData *data = [[NSFileHandle fileHandleForReadingAtPath:[[NSBundle mainBundle] pathForResource:@"ssssss" ofType:@"bin"]] readDataToEndOfFile];
    
    NSData *k4Data;
    if (self.currentRoundNumber == 0) {
        k4Data = [data subdataWithRange:NSMakeRange(0, 1024*4)];
    }else{
        if (data.length> 1024*4*self.currentRoundNumber+1024*4) {
            k4Data = [data subdataWithRange:NSMakeRange(1024*4*self.currentRoundNumber, 1024*4)];
        }else{
            k4Data = [data subdataWithRange:NSMakeRange(1024*4*self.currentRoundNumber, data.length - 1024*4*self.currentRoundNumber)];
        }
    }
    
    //总轮次
    NSInteger roundNumber = data.length%(1024*4)==0 ?((data.length/(1024*4))):((data.length/(1024*4))+1);

    //最后一轮的包数
    NSInteger lastPackage = (data.length - 1024*4*(roundNumber-1))%16==0?(data.length - 1024*4*(roundNumber-1))/16:(data.length - 1024*4*(roundNumber-1))/16+1;
    
    //256 = 1024*4/16;
    //总包数=满包次数*256
    self.totalNumber = (1024*4/16) * (roundNumber - 1) + lastPackage;
    
    //每一轮的总包数
    self.roundTotalNumber = ((NSInteger)k4Data.length % 16)== 0 ? (((NSInteger)k4Data.length / 16)) : (((NSInteger)k4Data.length / 16) +1);
    
    __weak typeof (self)weakSelf = self;
   self.timer = [NSTimer mk_scheduledTimerWithTimeInterval:.01 repeats:YES block:^{
       if (weakSelf.currentNumber>weakSelf.roundTotalNumber) {
           [weakSelf.timer invalidate];
           weakSelf.timer = nil;
       }
       [weakSelf sendPackage:k4Data];
    }];

}

- (void)sendPackage:(NSData *)data{
    
    NSUInteger packLoction;
    NSUInteger packLength;
    
    if (self.currentNumber>self.roundTotalNumber) { //这一轮结束  再判断是否最后一轮
        self.currentNumber = 0;
        
        //判断是否是最后一轮
//        if
        return;
    }
    
    if (self.currentNumber == self.roundTotalNumber) {
        packLength = 0;
    }else if (self.currentNumber == self.roundTotalNumber -1){
        packLength = [data length] - self.currentNumber * 16;
    }else{
        packLength = 16;
    }
    packLoction = self.currentNumber *16;
    
    //发送数据的地方
    NSData *sendDate = [data subdataWithRange:NSMakeRange(packLoction, packLength)];

    [self sendPackage:sendDate];
    
    self.currentNumber ++;
    
}

- (void)sendData:(NSData *)data{
    
    NSMutableData *sendData = [NSMutableData data];
    
    NSInteger currentIndex = self.totalNumber - self.currentRoundNumber*(1024*4/16)+self.currentNumber;
    
    NSString *headStr = [NSString stringWithFormat:@"0F%@%@",[[NSString getHexByDecimal:currentIndex] substringWithRange:NSMakeRange(0, 2)],[[NSString getHexByDecimal:currentIndex] substringWithRange:NSMakeRange(2, 2)]];
    
    
    [sendData appendData:[NSString convertHexStrToData:headStr]];
    [sendData appendData:data];
    
    
    //计算checkcode
    NSString *hexStr = [NSString convertDataToHexStr:sendData];;
    int totalNumber = 0;
    for (int i =0; i<hexStr.length; i+=2) {
        int sum = [[NSString hexStringToDecima:[hexStr substringWithRange:NSMakeRange(i, 2)]] intValue];
        
        totalNumber += sum;

    }
    //转16进制
    NSString * c = [NSString getHexByDecimal:totalNumber];
    if (c.length>=2) {
        // 拼接checkCode
       NSData *s = [NSString convertHexStrToData:[c substringWithRange:NSMakeRange(c.length-2, 2)]];
        [sendData appendData:s];
    }
    DLog(@"sendData:%@",sendData);
    
    [[HNBLEConnectManager shareInstance]writeValueToDevice:sendData];
}



#pragma  mark - OTA
- (void)DFUAction:(CBPeripheral *)peripheral{
//
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JQ_SDK14_DFU_APP_20180125_V1.4.0" ofType:@"zip"];
    NSURL  *url = [NSURL URLWithString:path];
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:url]; //filePath
    CBCentralManager *centralManager = [HNBLEConnectManager shareInstance].baby.centralManager;
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithCentralManager: centralManager target:peripheral];
    initiator.forceDfu = YES;
    initiator = [initiator withFirmware:selectedFirmware];
    initiator.logger = self;
    initiator.delegate = self;
    initiator.progressDelegate = self;
    [initiator start];
}

#pragma  mark - BLEDelegate
- (void)connectDeviceSucceed:(CBPeripheral *)peripheral{
    [MBProgressHUD showSuccess:NSLocalizedString(@"开始固件升级", nil)];
    self.mbp.label.text = NSLocalizedString(@"正在升级", nil);
    [self DFUAction:peripheral];
}
- (void)disConnectDevice:(CBPeripheral *)peripheral errro:(NSError *)error{
    if (error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:NSLocalizedString(@"升级失败", nil)];
    }
}
#pragma  mark - DFU
- (void)dfuStateDidChangeTo:(enum DFUState)state{
    NSLog(@"DFUState state%ld",(long)state);
    if (state == 6) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:NSLocalizedString(@"升级成功", nil)];
    }
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message{
    NSLog(@"Error %ld: %@", (long) error, message);
}

- (void)logWith:(enum LogLevel)level message:(NSString *)message{

}

//进度？
- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    
    DLog(@"进度:%ld",progress/totalParts);
}

#pragma  mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNOTACell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNOTACell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            cell.nameLabel.text = NSLocalizedString(@"蓝牙芯片版本", nil);
            cell.versionLabel.text = @"V-L2018";
            cell.checkLabel.text = NSLocalizedString(@"最新版本", nil);
        }
            break;
            
        default:
        {
            cell.nameLabel.text = NSLocalizedString(@"主控芯片版本", nil);
            cell.versionLabel.text = @"V-L2018";
            cell.checkLabel.text = NSLocalizedString(@"最新版本", nil);
        }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self checkVesion];
    }else{
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
#pragma  mark - 布局
- (void)masLayoutSubview{
//    if (![HNBLEConnectManager shareInstance].currentDevice) {
//        return;
//    }

    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(15);
        make.left.mas_equalTo(self.view).mas_offset(20);

    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.noticeLabel.mas_bottom).mas_offset(30);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view);
        }
        
    }];
}

#pragma  mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        self.view.backgroundColor = [UIColor colorWithHexString:@"E7E7E7"];
        _tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"HNOTACell" bundle:nil] forCellReuseIdentifier:@"HNOTACell"];
    }
    return _tableView;
}

- (UILabel *)noticeLabel{
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.text = NSLocalizedString(@"精彩功能即将上线，请耐心等候", nil);
        _noticeLabel.textColor = [UIColor grayColor];
        _noticeLabel.numberOfLines = 0;
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_noticeLabel];
        _noticeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _noticeLabel;
}

- (MBProgressHUD *)mbp{
    if (!_mbp) {
        _mbp = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    return _mbp;
}
@end
