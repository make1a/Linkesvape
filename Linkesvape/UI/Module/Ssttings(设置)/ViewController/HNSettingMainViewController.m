//
//  HNSettingMainViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNSettingMainViewController.h"
#import "HNSettingPwdFirstViewController.h"
#import "HNLanguageViewController.h"
#import "HNSettingPwdViewController.h"
#import "HNLoginViewController.h"
#import "HNSettingsCell.h"
#import "HNBaseNavigationController.h"
#import "AppDelegate.h"
#import "HNNoticeInfoView.h"
#import "HNWebViewController.h"

@interface HNSettingMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)HNNoticeInfoView * alertView;
@end

@implementation HNSettingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"设置", nil)];
}


#pragma  mark - 网络请求
-(void)checkPwd{
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:CheckPwd requestParameters:nil requestHeader:nil success:^(id responseObject) {
        if ([responseObject[@"d"][@"has_pwd"]integerValue] == 1) { //设置过密码
            HNSettingPwdFirstViewController *vc = [HNSettingPwdFirstViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{ //没设置过密码
            HNSettingPwdViewController *vc = [HNSettingPwdViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } faild:^(NSError *error) {
        ERROR;
    }];
}

- (void)outLoagin{
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:Logout requestParameters:nil requestHeader:nil success:^(id responseObject) {
        if (CODE == 200) {
            [MBProgressHUD showSuccess:responseObject[@"m"]];
            
            // 清除本地保存的userID
            [UserDefault setValue:@"" forKey:@"userId"];
            HNLoginViewController *loginVC = [HNLoginViewController new];
            HNBaseNavigationController *nav = [[HNBaseNavigationController alloc]initWithRootViewController:loginVC];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }
    } faild:^(NSError *error) {
        ERROR;
    }];
}
#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = NSLocalizedString(@"密码设置", nil);
                cell.detailTextLabel.text = @"";
            }
                break;
            case 1:
            {
                cell.textLabel.text = NSLocalizedString(@"语言设置", nil);
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:HNUserDefaultLanguage] containsString:@"en"]) {
                    cell.detailTextLabel.text = @"English";
                }else{
                    cell.detailTextLabel.text = @"中文";
                }
            }
                break;
            case 2:
            {
                cell.textLabel.text = NSLocalizedString(@"图片传输", nil);
                cell.detailTextLabel.text = @"";
                
            }
                break;
                
            default:
            {
                cell.textLabel.text = NSLocalizedString(@"关于linkedvape", nil);
                cell.detailTextLabel.text = @"";
                
            }
                break;
        }
        return cell;
        
    }else{
        HNSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNSettingsCell"];
        if (!cell) {
            cell = [[HNSettingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNSettingsCell"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                [self checkPwd];
            }
                break;
            case 1:
            {
                HNLanguageViewController *vc = [HNLanguageViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                //语言
                NSString * language = [[NSUserDefaults standardUserDefaults]valueForKey:HNUserDefaultLanguage];
                HNWebViewController *vc = [HNWebViewController new];
                vc.urlString = [NSString stringWithFormat:@"http://118.126.111.250/h5/index/detail?Accept-Language=%@&type=about_us",language];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tableView);
            make.left.right.bottom.mas_equalTo([UIApplication sharedApplication].keyWindow);
        }];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Handle_height(48);
}
#pragma  mark - 布局
- (void)masLayoutSubview{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view);
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (HNNoticeInfoView *)alertView{
    if (!_alertView) {
        _alertView = [[HNNoticeInfoView alloc]init];
        _alertView.titleLabel.text = NSLocalizedString(@"是否退出登录", nil);
        _alertView.detailLabel.text = NSLocalizedString(@"退出当前登录账号", nil);
        _weakself;
        _alertView.pressRightButton = ^{
            [weakself outLoagin];
        };
    }
    return _alertView;
}
@end
