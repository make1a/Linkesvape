//
//  HNAddPictureView.m
//  JinDouShop
//
//  Created by Sunwanwan on 2017/3/28.
//  Copyright © 2017年 HN. All rights reserved.
//

#import "HNAddPictureView.h"

#define padding  Handle(20)
//#define pictureWH Handle(76)
#define deleteBtnWH Handle(20)
static NSInteger MaxImageCount = 3;
static NSInteger imageTag = 2000;

@interface HNAddPictureView ()
{
    NSString *viewTitle;
    UIView *imagePickerView;
}

@end

@implementation HNAddPictureView

+ (HNAddPictureView *)addPictureViewWithTitle:(NSString *)title frame:(CGRect)frame
{
    return [[HNAddPictureView alloc] initWithTitle:title frame:frame];
}

- (id)initWithTitle:(NSString *)title frame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        viewTitle = title;
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, frame.origin.y, SCREEN_WIDTH, Handle_height(148));
        
        [self creatFeedbackImageView];
    }
    return self;
}

- (void)creatFeedbackImageView
{
    // 图片所在区域
    UIImage *addImage = GetImage(@"btn_add_picture");
    imagePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, Handle(5), self.width, addImage.size.height + 20)];
    imagePickerView.backgroundColor = [UIColor clearColor];
    [self addSubview:imagePickerView];
    
    [self reloadImagePickerViewWithImagePickerArray:self.imagePickerArray];
}

- (CGFloat)viewHeight
{
    return imagePickerView.bottom;
}

- (void)reloadImagePickerViewWithImagePickerArray:(NSMutableArray *)array
{
    for (UIView *view in imagePickerView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIImage *addImage = GetImage(@"btn_add_picture");
    CGFloat pictureWH = addImage.size.height;
    
    // 根据imagePickerArray的数量来创建
    NSInteger imageCount = array.count;
    for (int i = 0; i < imageCount; i ++)
    {
        UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding + (i % 3) * (pictureWH + Handle(14)), 0, pictureWH, pictureWH)];
        pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        pictureImageView.clipsToBounds = YES;
        
        // 放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeImageView:)];
        [pictureImageView addGestureRecognizer:tap];
        
        // 添加删除按钮
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleBtn.frame = CGRectMake(pictureWH - deleteBtnWH, 0, deleteBtnWH, deleteBtnWH);
        [deleBtn setImage:[UIImage imageNamed:@"delete_picture"] forState:UIControlStateNormal];
        [deleBtn addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        deleBtn.tag = i;
        [pictureImageView addSubview:deleBtn];
        
        pictureImageView.tag = imageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        
//        if ([[array objectAtIndex:i] isKindOfClass:[ALAsset class]])
//        {
//            pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[array objectAtIndex:i]).thumbnail];
//        }
//        else
//        {
//            pictureImageView.image = [array objectAtIndex:i];
//        }
        
        pictureImageView.image = [array objectAtIndex:i];
        
        [imagePickerView addSubview:pictureImageView];
    }

    if (imageCount < MaxImageCount)
    {
        UIButton *addPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addPictureBtn.frame = CGRectMake(padding + (imageCount % 3) * (pictureWH + Handle(14)), 0, pictureWH, pictureWH);
        [addPictureBtn setBackgroundImage:GetImage(@"btn_add_picture") forState:UIControlStateNormal];
        [addPictureBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
        [imagePickerView addSubview:addPictureBtn];
        
        [addPictureBtn setEnlargeEdgeWithTop:10 right:10 bottom:20 left:10];
        
        if (imageCount == MaxImageCount)
        {
            [addPictureBtn removeFromSuperview];
        }
    }
}

#pragma mark - privateMethod

// 屏蔽图片事件
- (void)imageViewActionInvalid
{
    for (UIImageView *imageView in imagePickerView.subviews)
    {
        imageView.userInteractionEnabled = NO;
    }
}

// 解除图片屏蔽
- (void)removeImageViewActionInvalid
{
    for (UIImageView *imageView in imagePickerView.subviews)
    {
        imageView.userInteractionEnabled = YES;
    }
}

// 放大图片
- (void)enlargeImageView:(UITapGestureRecognizer *)tap
{
    if (self.enlargeImageView)
    {
        self.enlargeImageView(tap.view.tag);
    }
}

// 删除图片
- (void)deletePic:(UIButton *)btn
{
    if (self.deleteImageView)
    {
        self.deleteImageView(btn);
    }
}

// 添加图片
- (void)addPicture
{
    if (self.addImageView)
    {
        self.addImageView();
    }
}


#pragma mark - setter

- (void)setImagePickerArray:(NSMutableArray *)imagePickerArray
{
    _imagePickerArray = imagePickerArray;
    
    [self reloadImagePickerViewWithImagePickerArray:imagePickerArray];
}


@end
