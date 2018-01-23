//
//  HNMainNewsCell.h
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNBannerModel.h"

@interface HNMainNewsCell : UITableViewCell
@property (nonatomic,strong)UILabel * headTitleLabel;
@property (nonatomic,strong)UILabel * timeLabel;
@property (nonatomic,strong)UIImageView * headImageView;

- (void)cellRefreshWithModel:(HNNewsModel *)model;
@end
