//
//  HNNameEditCell.m
//  Linkesvape
//
//  Created by make on 2018/1/3.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNNameEditCell.h"

@implementation HNNameEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.text = NSLocalizedString(@"模式名称", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
