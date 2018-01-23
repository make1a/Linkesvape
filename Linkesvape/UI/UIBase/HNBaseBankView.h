//
//  HNBaseBankView.h
//  LiveShow
//
//  Created by Sunwanwan on 2017/8/10.
//  Copyright © 2017年 HN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNBaseBankView : UIView

// 可在外部修改刷新按钮的标题
@property (nonatomic, strong) UIButton *refreshBtn;

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, strong) void(^refreshBtnClick) ();

@end
