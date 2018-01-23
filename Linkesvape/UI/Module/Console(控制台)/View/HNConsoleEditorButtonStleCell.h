//
//  HNConsoleEditorButtonStleCell.h
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNConsoleEditorButtonStleCell : UITableViewCell
@property (nonatomic,strong)UILabel * colorNameLabel;
@property (nonatomic,strong)UILabel * hzLabel;
@property (nonatomic,strong)UIButton * lightButton;
@property (nonatomic,strong)UIButton * flashButton;
@property (nonatomic,strong)UIButton * slowButton;
@property (nonatomic,strong)UIButton * saveButton;
@property (nonatomic,strong)UIButton * cancleButton;



/**
 保存
 */
@property (nonatomic,copy)void (^pressSaveBtnBlock)(void);

//退出
@property (nonatomic,copy)void (^pressCancleBtnBlock)(void);

//选择颜色
@property (nonatomic,copy)void (^pressSelectColorBtnBlock)(NSInteger tag);

//选择Hz
@property (nonatomic,copy)void (^pressSelectHZBtnBlock)(NSInteger tag);
@end
