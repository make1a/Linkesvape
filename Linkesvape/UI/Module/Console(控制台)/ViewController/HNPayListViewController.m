//
//  HNPayListViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNPayListViewController.h"
#import "HNConsoleHistroyViewController.h"

#import "HNPayListHeadView.h"
#import "HNSettingsCell.h"
#import "HNConsoleListCell.h"

#import "HNPlayListModel.h"

@interface HNPayListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation HNPayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPlayList];
}
- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"播放列表", nil)];
}
#pragma mark - 网络请求
- (void)requestPlayList{
//    NSDictionary *dic = @{@"type":@""};
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypeGET requestAPICode:PlayList requestParameters:nil requestHeader:nil success:^(id responseObject) {
        DLog(@"responseObject==%@",responseObject);
        if (CODE == 200) {
            NSArray *array = responseObject[@"d"][@"list"];
            [self.dataSource removeAllObjects];
            for (NSDictionary *dic in array) {
                HNPlayModel *model = [HNPlayModel yy_modelWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        }
    } faild:^(NSError *error) {
        ERROR;
    }];
    
}

- (void)sortDataSource{
    
    NSMutableString *string = [@"" mutableCopy];
    
    for (HNPlayModel *model in self.dataSource) {
        if (model == self.dataSource.lastObject) {
            [string appendFormat:@"%@",model.modelId];
        }else{
            [string appendFormat:@"%@,",model.modelId];
        }
    }
    NSDictionary *dic = @{@"play_list":string};
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:OrderPlayMode requestParameters:dic requestHeader:nil success:^(id responseObject) {
        if (CODE == 200) {
            [MBProgressHUD showSuccess:NSLocalizedString(@"修改成功", nil)];
            [self.tableView reloadData];
        }else{
            MBErrorMsg;
        }
    } faild:^(NSError *error) {
        ERROR;
    }];
    
}

- (void)removeModelFromList:(HNPlayModel *)model indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = @{@"play_id":model.modelId};
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:DeletePlayer requestParameters:dic requestHeader:nil success:^(id responseObject) {
        if (CODE == 200) {
            [MBProgressHUD showSuccess:NSLocalizedString(@"删除成功", nil)];
            [self.dataSource removeObject:model]; //删除
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            MBErrorMsg;
        }
        
    } faild:^(NSError *error) {
        ERROR;
    }];
}
#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HNPlayModel *model = self.dataSource[indexPath.row];
    HNConsoleListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConsoleListCell"];
    if (!cell) {
        cell = [[HNConsoleListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConsoleListCell"];
    }
    cell.rightButton.hidden = YES;
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.nameLabel.text = model.name;
    return cell;
}

//这个方法就是执行移动操作的
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    id object = [self.dataSource objectAtIndex:fromRow];
    [self.dataSource removeObjectAtIndex:fromRow];
    [self.dataSource insertObject:object atIndex:toRow];
    DLog(@"%@",self.dataSource);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.tableView.editing == YES){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *actionDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        HNPlayModel *model = self.dataSource[indexPath.row];
//        [self.dataSource removeObject:model]; //删除
        [self removeModelFromList:model indexPath:indexPath];
    }];
    actionDelete.backgroundColor = [UIColor redColor];
    return @[actionDelete];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Handle_width(92/2);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HNPayListHeadView *headView = [HNPayListHeadView new];
    headView.playLabel.text = NSLocalizedString(@"顺序播放", nil);
    //    headView.titleLabel.text = NSLocalizedString(@"()", nil);
    headView.pressEditButton = ^{
        self.tableView.editing = !tableView.editing;
        if (tableView.editing == NO) { //完成编辑
            [self sortDataSource];
        }
    };
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Handle_height(40);
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

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}
@end


