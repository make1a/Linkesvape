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

@import iOSDFULibrary;

@interface HNOTAViewController ()<UITableViewDelegate,UITableViewDataSource,LoggerDelegate,DFUProgressDelegate,DFUServiceDelegate>
@property (nonatomic,strong)UILabel * noticeLabel;
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation HNOTAViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![HNBLEConnectManager shareInstance].currentDevice) {
        [self loadAbankViewWithSuperView:self.view frame:self.view.bounds imageStr:@"unconnected_device" descStr:NSLocalizedString(@"需要连接设备才能继续操作哦~", nil)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"控制台", nil)];

}

- (void)DFUAction{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JQ_SDK14_DFU_APP_20180119" ofType:@"zip"];
    NSURL  *url = [NSURL URLWithString:path];
    
    DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:url];// or
    
    CBCentralManager *centralManager = [HNBLEConnectManager shareInstance].baby.centralManager;
    CBPeripheral *selectedPeripheral = [HNBLEConnectManager shareInstance].currentDevice.peripheral;
    
    DFUServiceInitiator *initiator = [[DFUServiceInitiator alloc] initWithCentralManager: centralManager target:selectedPeripheral];
    [initiator withFirmware:selectedFirmware];
    // Optional:
    // initiator.forceDfu = YES/NO; // default NO
    // initiator.packetReceiptNotificationParameter = N; // default is 12
    initiator.logger = self;
    initiator.delegate = self;
    initiator.progressDelegate = self;
    // initiator.peripheralSelector = ... // the default selector is used
    [initiator start];
    //    DFUServiceController *controller = [initiator start];

}

#pragma  mark - DFU
- (void)dfuStateDidChangeTo:(enum DFUState)state{
    NSLog(@"DFUState state%ld",state);
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message{
    NSLog(@"Error %ld: %@", (long) error, message);
}

- (void)logWith:(enum LogLevel)level message:(NSString *)message{

}


//进度？
- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    
    DLog(@"进度:%ld-%ld",progress/totalParts);
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
    [HNDFUModel sendOTACode];
    [self DFUAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
#pragma  mark - 布局
- (void)masLayoutSubview{
    if (![HNBLEConnectManager shareInstance].currentDevice) {
        return;
    }

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
@end
