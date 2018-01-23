//
//  HNMainTableHeadView.m
//  Linkesvape
//
//  Created by make on 2017/12/28.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNMainTableHeadView.h"

@implementation HNMainTableHeadView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.labelBottomConstraint.constant = Handle_height(10);
}
- (IBAction)clickButton:(id)sender {
    if (self.pressRightButtonBlock) {
        self.pressRightButtonBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
