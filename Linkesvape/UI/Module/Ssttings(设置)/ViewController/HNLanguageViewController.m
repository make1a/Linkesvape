//
//  HNLanguageViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/2.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNLanguageViewController.h"
#import "HNLanguageCell.h"
#import "HNBaseLiveTabBarController.h"

@interface HNLanguageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)NSInteger selectIndex ;

@end

@implementation HNLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self findCurrentLanguage];
}


- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"语言设置", nil)];
}

- (void)findCurrentLanguage{
    NSString *language = [[NSUserDefaults standardUserDefaults]valueForKey:HNUserDefaultLanguage];
    if ([language containsString:@"en"]) {
        self.selectIndex = 1;
    }else{
        self.selectIndex = 0;
    }
    [self.tableView reloadData];
}

#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNLanguageCell"];
    if (!cell) {
        cell = [[HNLanguageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNLanguageCell"];
    }
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"简体中文";
    }else{
        cell.titleLabel.text = @"English";
    }
    
    if (indexPath.row==self.selectIndex) {
        cell.checkImageView.hidden = NO;
    }else{
        cell.checkImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

   HNAlertView *alertView = [[HNAlertView alloc]initWithTitle:NSLocalizedString(@"确定切换语言？", nil) Content:nil whitTitleArray:@[NSLocalizedString(@"确定", nil),NSLocalizedString(@"取消", nil)] withType:@"center"];
    
    [alertView showAlertView:^(NSInteger index) {
        if (index == 0) {
            NSString *language;
            switch (indexPath.row) {
                case 1:
                {
                    [NSBundle setLanguage:@"en"];
                    language = @"en";
                }
                    break;
                    
                default:
                {
                    [NSBundle setLanguage:@"zh-Hans"];
                    language = @"zh-Hans";
                }
                    break;
            }
            [[NSUserDefaults standardUserDefaults] setObject:language forKey:HNUserDefaultLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [alertView dissmis];
            HNBaseLiveTabBarController *vc = [[HNBaseLiveTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;

        }else{
            [alertView dissmis];
        }
    }];

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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"E7E7E7"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end




