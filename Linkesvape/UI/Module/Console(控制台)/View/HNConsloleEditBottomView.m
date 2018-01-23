//
//  HNConsloleEditBottomView.m
//  Linkesvape
//
//  Created by make on 2018/1/4.
//  Copyright © 2018年 make. All rights reserved.
//

#import "HNConsloleEditBottomView.h"
#import "UIImage+TinColor.h"

@interface HNConsloleEditBottomView ()

@property (nonatomic,strong)NSTimer * lightPreviewTimer;

@property (nonatomic,assign)BOOL  isPreview; //是否正在预览

@end

@implementation HNConsloleEditBottomView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self masLayoutSubviews];
    }
    return self;
}

#pragma  mark - 接口
- (void)previewLightWithModel:(HNCustomInfoModel *)model{

    __block int number = 0;

        if (!self.lightPreviewTimer) {
            self.lightPreviewTimer = [NSTimer mk_scheduledTimerWithTimeInterval:.2 repeats:YES block:^{
                
                if (number == 15) { //预览结束
                    [self  outPreView];
                    return ;
                }
                
                int  lightId = 0;
                for (HNSingleLightModel *singleLight in model.lamps) {
                    
                    HNLightInfoModel *info = singleLight.infos[number];
                    UIImageView *imageView = (UIImageView *)[self viewWithTag:100+lightId];
                    if (info.color == 0 || info.color.length == 0) {
                        info.color = @"e7e7e7";
                    }
                    UIImage *image = [UIImage imageNamed:@"preview_the_lamp"];
                    imageView.image =  [image imageWithTintColor:[UIColor colorWithHexString:info.color]];
                    lightId ++;
                }
                number ++;
            }];
        }
}

//退出预览
- (void)outPreView{
    [self.lightPreviewTimer invalidate];
    self.lightPreviewTimer = nil;
    self.isPreview = NO;
    self.preViewButton.selected = NO;
    
    for (int i = 0; i<7; i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:100+i];
        UIImage *image = [UIImage imageNamed:@"preview_the_lamp"];
        imageView.image =  [image imageWithTintColor:[UIColor colorWithHexString:@"e7e7e7"]];
    }

}

#pragma  mark - actions
- (void)clickPreViewBtnAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) { //预览中
        self.isPreview = YES;
        if (self.preViewLightColor) {
            self.preViewLightColor();
        }
        
    }else{
        [self  outPreView];
    }
    
    
}
    
    


#pragma  mark - 布局
- (void)masLayoutSubviews{
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(14));
        make.top.mas_equalTo(self).mas_offset(Handle_height(20));
    }];
    
    [self.sumbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-Handle_width(50));
        make.top.mas_equalTo(self.textLabel.mas_bottom).mas_offset(Handle_height(25));
        make.width.mas_equalTo(Handle_width(130));
        make.height.mas_equalTo(Handle_height(44));
    }];
    
    [self.preViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(Handle_width(50));
        make.top.height.width.mas_equalTo(self.sumbButton);
    }];
    
    UIImage *image = [UIImage imageNamed:@"preview_the_lamp"];
    CGFloat w = image.size.width;
    CGFloat space = Handle_width(20);
    CGFloat h = image.size.height;
    for (int i = 0; i<6; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(Handle_width(185/2)+i*(w+space), Handle_height(20), w, h);
//        imageView.tintColor = [UIColor greenColor];
//        [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        image = [image imageWithTintColor:[UIColor colorWithHexString:@"e7e7e7"]];
        imageView.image = image;
        [self addSubview:imageView];
        imageView.tag = 100+i;
    }
}

#pragma  mark - 懒加载
- (UILabel *)textLabel
{
    if(!_textLabel)
    {
        UIView *superView = self;
        _textLabel = [[UILabel alloc]init];
        [superView addSubview:_textLabel];
        [_textLabel setFont:[UIFont systemFontOfSize:Handle_width(15)]];
        [_textLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
         _textLabel.text = NSLocalizedString(@"预览效果", nil);
    }
    return _textLabel;
}
- (UIButton *)preViewButton
{
    if(!_preViewButton)
    {
        UIView *superView = self;
        _preViewButton = [[UIButton alloc]init];
        [superView addSubview:_preViewButton];
        [_preViewButton setTitle:NSLocalizedString(@"预览", nil) forState:UIControlStateNormal];
        [_preViewButton setTitle:NSLocalizedString(@"退出预览", nil) forState:UIControlStateSelected];
        [_preViewButton setBackgroundColor:[UIColor clearColor]];
        [_preViewButton setTitleColor:[UIColor colorWithHexString:@"1d98f2"] forState:UIControlStateNormal];
        _preViewButton.layer.masksToBounds = YES;
        _preViewButton.layer.cornerRadius = 5.f;
        _preViewButton.layer.borderColor = [UIColor colorWithHexString:@"1d98f2"].CGColor;
        _preViewButton.layer.borderWidth = 1.f;
        [_preViewButton addTarget:self action:@selector(clickPreViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preViewButton;
}
- (UIButton *)sumbButton
{
    if(!_sumbButton)
    {
        UIView *superView = self;
        _sumbButton = [[UIButton alloc]init];
        [superView addSubview:_sumbButton];
        [_sumbButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [_sumbButton setBackgroundColor:[UIColor colorWithHexString:@"1d98f2"]];
        _sumbButton.layer.cornerRadius = 5.f;
        _sumbButton.layer.masksToBounds = YES;
    }
    return _sumbButton;
}

@end
