//
//  HNConsloleEditBottomView.h
//  Linkesvape
//
//  Created by make on 2018/1/4.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNSingleLightModel.h"

@interface HNConsloleEditBottomView : UIView
@property (nonatomic,strong)UILabel * textLabel;
@property (nonatomic,strong)UIButton * preViewButton;
@property (nonatomic,strong)UIButton * sumbButton;
@property (nonatomic,assign,readonly)BOOL  isPreview; //是否正在预览
- (void)previewLightWithModel:(HNCustomInfoModel *)model;
@property (nonatomic,copy)void(^preViewLightColor)(void);

@end
