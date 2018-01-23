//
//  HNNoticeInfoView.h
//  Linkesvape
//
//  Created by make on 2017/12/29.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNNoticeInfoView : UIView
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * detailLabel;
@property (nonatomic,strong)UIButton * sumbitButton;
@property (nonatomic,strong)UIButton * cancelButton;
@property (nonatomic,copy)void (^pressRightButton)(void);

@end
