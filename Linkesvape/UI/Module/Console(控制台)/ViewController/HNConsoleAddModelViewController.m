//
//  HNConsoleAddModelViewController.m
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsoleAddModelViewController.h"


//views
#import "HNNameEditCell.h"
#import "HNConsoleSliderCell.h"
#import "HNTableHedView.h"
#import "HNConsoleModelEditCell.h"
#import "HNConsoleEditorButtonStleCell.h"
#import "HNConsloleEditBottomView.h"

//model
#import "HNSingleLightModel.h"

@interface HNConsoleAddModelViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *_colorString; //颜色
    NSString *_hzString;
    NSString *_nameString;
    CGFloat _sliderValue;
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,assign)NSInteger  selectSection;
@property (nonatomic,assign)NSInteger currentBtnIndex;
@property (nonatomic,strong)HNCustomInfoModel * customInfo;

@end

@implementation HNConsoleAddModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectSection = -1;
    self.currentBtnIndex = -1;
}
- (void)setNavigationStyle{
    [self setNavigationTitle:NSLocalizedString(@"新增模式", nil)];
}




#pragma  mark - actions
- (void)saveInfo:(id)sender{
    
    //名称

    NSString *name = _nameString;
   
    if (name.length == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入模式名称", nil)];
        return;
    }
    
    //亮度
    
    CGFloat value = _sliderValue;
    self.customInfo.light = [NSString stringWithFormat:@"%.0f",value];
    
    NSString *content = [self.customInfo yy_modelToJSONString];;
    DLog(@"content的内容:%@",content);
    
    NSDictionary *dic = @{@"name":name,@"content":content};
    
    [HNRequestManager sendRequestWithRequestMethodType:HNRequestMethodTypePOST requestAPICode:SaveModel requestParameters:dic requestHeader:nil success:^(id responseObject) {
        if (CODE == 200) {
            [MBProgressHUD showSuccess:NSLocalizedString(@"上传成功", nil)];
        }else{
            [MBProgressHUD showError:responseObject[@"m"]];
        }
        
    } faild:^(NSError *error) {
        ERROR;
    }];
}
//退出逻辑
- (void)outAction{
    _colorString = nil;
    _hzString = nil;
    self.selectSection = -1;
    [self.tableView reloadData];
}

//保存信息
- (void)saveAction{
    if (self.currentBtnIndex == -1) {
        [MBProgressHUD showError:NSLocalizedString(@"请先选择时间段", nil)];
        return;
    }
    if (self.selectSection == -1) {
        return;
    }
    HNSingleLightModel *singleLight = self.customInfo.lamps[self.selectSection-2]; //第几个灯
    HNLightInfoModel *lightInfo = singleLight.infos[self.currentBtnIndex]; //第几个button
    lightInfo.color = _colorString;
    lightInfo.hz = _hzString;
    [self.tableView reloadData];
}
- (void)sliderChangeValue:(UISlider *)sender{
    _sliderValue = sender.value;
}


#pragma  mark - textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _nameString = textField.text;
}
#pragma  mark - tableview dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectSection == section) {
        return 2;
    }
    if (section>=2 && section<=7) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            HNNameEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNNameEditCell"];
            cell.textField.delegate = self;
            return cell;
        }
            break;
        case 1:
        {
            HNConsoleSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConsoleSliderCell"];
            [cell.slider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
            return cell;
            
        }
            break;
        default:
        {
            if (indexPath.row == 0)
            {
                HNConsoleModelEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConsoleModelEditCell"];
                if (!cell) {
                    cell = [[HNConsoleModelEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConsoleModelEditCell"];
                    cell.pressEditBtnBlock = ^{ //点击收缩编辑cell
                        [self didselectRowAction:indexPath];
                    };
                    
                    cell.pressDeviceBtnBlock = ^(NSInteger tag) { //点击按钮
                        self.currentBtnIndex = tag;  //选择第self.currenSection段  第self.currentBtnIndex行
                    };
                }
                
                [cell cellRefreshWithIndexPath:indexPath.section andModel:self.customInfo andSelectIndex:self.currentBtnIndex selectSection:self.selectSection];
                
                return cell;
            }else{
                
                HNConsoleEditorButtonStleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNConsoleEditorButtonStleCell"];
                if (!cell) {
                    cell = [[HNConsoleEditorButtonStleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HNConsoleEditorButtonStleCell"];
                    
                    cell.pressSelectColorBtnBlock = ^(NSInteger tag) { //选择颜色
                        _colorString = [HNLightInfoModel ColorStringWithindex:tag];
                    };
                    
                    cell.pressSelectHZBtnBlock = ^(NSInteger tag) {
                        _hzString = [NSString stringWithFormat:@"%ld",(long)tag];
                    };
                    cell.pressCancleBtnBlock = ^{ //退出
                        [self outAction];
                    };
                    
                    cell.pressSaveBtnBlock = ^{ //保存
                        [self saveAction];
                    };
                    
                }
                return cell;
            }
        }
            break;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self didselectRowAction:indexPath];
}
//收缩row
- (void)didselectRowAction:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section>1) {
        if (indexPath.section == self.selectSection) {
            self.selectSection = -1;
        }else{
            self.currentBtnIndex = -1;
            self.selectSection =  indexPath.section;
        }
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 7) {
        HNConsloleEditBottomView *footView = [HNConsloleEditBottomView new];
        [footView.sumbButton addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        //预览
        __weak typeof(footView) weakfootView = footView;
        footView.preViewLightColor = ^{
            [weakfootView previewLightWithModel:self.customInfo];
        };
        return footView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 7) {
        return Handle_height(328/2);
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HNTableHedView *headView = [[HNTableHedView alloc]init];
    headView.titleLabel.font = [UIFont systemFontOfSize:Handle_height(18)];
    headView.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    if (section == 1) {
        headView.titleLabel.text = NSLocalizedString(@"亮度", nil);
    }else if (section == 2){
        headView.titleLabel.text = NSLocalizedString(@"模式设置", nil);
    }else{
        headView.titleLabel.text = @"";
    }
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return Handle_height(98/2);
    }else if (indexPath.section >=2 && indexPath.section <= 7){
        return Handle_height(310/2);
    }
    return Handle_height(98/2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return Handle_height(98/2);
    }else{
        return Handle_height(10);
    }
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
        [_tableView registerNib:[UINib nibWithNibName:@"HNNameEditCell" bundle:nil] forCellReuseIdentifier:@"HNNameEditCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HNConsoleSliderCell" bundle:nil] forCellReuseIdentifier:@"HNConsoleSliderCell"];
    }
    return _tableView;
}
- (HNCustomInfoModel *)customInfo{
    if (!_customInfo) {
        _customInfo = [[HNCustomInfoModel alloc]init];
    }
    return _customInfo;
}
@end

