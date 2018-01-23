//
//  HNLoginTextFieldView.m
//  Linkesvape
//
//  Created by make on 2017/12/27.
//  Copyright © 2017年 make. All rights reserved.
//

#import "HNLoginTextFieldView.h"

@implementation HNLoginTextFieldView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.f;
        self.backgroundColor = [UIColor colorWithHexString:@"587279" alpha:.5];
        [self masLayoutSubviews];
    }
    return self;
}

- (void)masLayoutSubviews{
    [self.imageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(10));
        make.centerY.mas_equalTo(self);
        make.height.width.mas_equalTo(Handle_width(21));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(Handle_width(15));
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self.mas_height);
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UITextField *)textField
{
    if(!_textField)
    {
        UIView *superView = self;
        _textField = [[UITextField alloc]init];
        [superView addSubview:_textField];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor whiteColor];
        
        [_textField setValue:[UIColor colorWithHexString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _textField;
}

@end
