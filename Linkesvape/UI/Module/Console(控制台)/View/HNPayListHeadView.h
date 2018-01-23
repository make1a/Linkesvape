//
//  HNPayListHeadView.h
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HNPlayInOrder = 0, //顺序
    HNPlayrandom, //随机
    HNPlaycirculate, //循环
} HNPlayModelOrder;

@interface HNPayListHeadView : UIView
@property (nonatomic,strong)UIButton * leftButton;
@property (nonatomic,strong)UILabel * playLabel;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UIButton * rightButton;

@property (nonatomic,assign,setter=setPlayListOrder:)HNPlayModelOrder order;


@property (nonatomic,copy)void (^pressEditButton)(void);

@end
