//
//  HNOTACell.m
//  Linkesvape
//
//  Created by make on 2018/1/22.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNOTACell.h"

@implementation HNOTACell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redView.layer.masksToBounds = YES;
    self.redView.layer.cornerRadius = 2.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
