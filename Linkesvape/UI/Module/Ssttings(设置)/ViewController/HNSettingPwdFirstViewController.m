//
//  HNSettingPwdFirstViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNSettingPwdFirstViewController.h"
#import "HNSettingPwdSecondViewController.h"
#import "HNFindPwdViewController.h"
@interface HNSettingPwdFirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation HNSettingPwdFirstViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"密码设置", nil)];
}


#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellFirst"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellFirst"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = NSLocalizedString(@"我记得原始密码", nil);
            cell.detailTextLabel.text = @"";
        }
            break;
            
        default:
        {
            cell.textLabel.text = NSLocalizedString(@"我忘记原密码", nil);
            cell.detailTextLabel.text = @"";
            
        }
            break;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            HNSettingPwdSecondViewController *vc = [HNSettingPwdSecondViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
        {
            HNFindPwdViewController *vc = [HNFindPwdViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end

