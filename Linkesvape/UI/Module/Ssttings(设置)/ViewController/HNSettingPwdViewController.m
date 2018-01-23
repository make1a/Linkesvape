//
//  HNSettingPwdViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNSettingPwdViewController.h"
#import "HNSettingPwdCell.h"
#import "HNSettingPwdButtonCell.h"


@interface HNSettingPwdViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation HNSettingPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"密码设置", nil)];
}
//设置密码
- (void)configPwd{
    HNSettingPwdCell *cell0 =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    HNSettingPwdCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *pwd = cell0.textField.text;
    NSString *confirmPwd = cell1.textField.text;
    
    
    if (pwd.length == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入密码", nil)];
        return;
    }
    
    if (confirmPwd.length == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入确认密码", nil)];
        return;
    }
    
    if (![pwd isEqualToString:confirmPwd]) {
        [MBProgressHUD showError:NSLocalizedString(@"两次密码输入不一致", nil)];
        return;
    }
    
    if (confirmPwd.length>16 || pwd.length>16) {
        [MBProgressHUD showError:NSLocalizedString(@"密码太长", nil)];
        return;
    }
    
    if (confirmPwd.length<6 || pwd.length < 6) {
        [MBProgressHUD showError:NSLocalizedString(@"密码太短", nil)];
    }
    
    
    NSDictionary *dic = @{@"password":pwd,@"confirm_password":confirmPwd};
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:ConfigPwd requestParameters:dic requestHeader:nil success:^(id responseObject) {
        if (CODE == 200) {
            [MBProgressHUD showSuccess:responseObject[@"m"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
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
    if (section == 1) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HNSettingPwdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNSettingPwdCell"];
        if (!cell) {
            cell = [[HNSettingPwdCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HNSettingPwdCell"];
        }
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLabel.text = NSLocalizedString(@"设置密码", nil);
                cell.textField.placeholder = NSLocalizedString(@"请输入原密码", nil);
            }
                break;

            default:
            {
                cell.titleLabel.text = NSLocalizedString(@"确认密码", nil);
                cell.textField.placeholder = NSLocalizedString(@"请再次输入新密码", nil);
            }
                break;
        }
        return cell;
    }else{
        HNSettingPwdButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNSettingPwdButtonCell"];
        if (!cell) {
            cell = [[HNSettingPwdButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNSettingPwdButtonCell"];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            if (indexPath.section == 1) {
                [self configPwd];
            }
            
        }
            break;
            
        default:
            break;
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"E7E7E7"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end



