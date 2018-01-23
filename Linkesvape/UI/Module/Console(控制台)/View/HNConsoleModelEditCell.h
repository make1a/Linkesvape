//
//  HNConsoleModelEditCell.h
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNSingleLightModel.h"
@interface HNConsoleModelEditCell : UITableViewCell
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UIButton * editButton;

@property (nonatomic,copy)void (^pressDeviceBtnBlock)(NSInteger tag);

@property (nonatomic,copy)void (^pressEditBtnBlock)(void);

//所有按钮回复普通状态
- (void)setButtonStatusNor;

- (void)setButtonColor:(NSString *)hexColor AndIndex:(NSInteger)tag;


/**
 刷新

 @param section indexPath.section
 @param info info
 @param selectIndex 选中第几个button
 @param selectSection 选中section
 */
- (void)cellRefreshWithIndexPath:(NSInteger )section andModel:(HNCustomInfoModel *)info andSelectIndex:(NSInteger)selectIndex selectSection:(NSInteger)selectSection;
@end
