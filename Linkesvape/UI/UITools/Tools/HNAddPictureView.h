//
//  HNAddPictureView.h
//  JinDouShop
//
//  Created by Sunwanwan on 2017/3/28.
//  Copyright © 2017年 HN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNAddPictureView : UIView

// 放大图片事件回调
@property (nonatomic, copy) void(^enlargeImageView)(NSInteger imgTag);

// 删除图片事件回调
@property (nonatomic, copy) void(^deleteImageView)(UIButton *btn);

// 添加图片事件回调
@property (nonatomic, copy) void(^addImageView)();

@property (nonatomic, strong) NSMutableArray *imagePickerArray;

// 根据title区分是评论订单还是晒单
+ (HNAddPictureView *)addPictureViewWithTitle:(NSString *)title
                                        frame:(CGRect)frame;

// 重新设置图片区域
- (void)reloadImagePickerViewWithImagePickerArray:(NSMutableArray *)array;

// 屏蔽图片事件
- (void)imageViewActionInvalid;

// 移除图片屏蔽事件
- (void)removeImageViewActionInvalid;

- (CGFloat)viewHeight;

@end
