//
//  CollectionViewCell.m
//  BKUploadCollectionView
//
//  Created by Derrick on 2018/1/19.
//  Copyright © 2018年 bike. All rights reserved.
//

#import "BKUploadImageCell.h"
#import "BKProgressBarView.h"
#import "BKUploadImageModel.h"

#pragma mark - BKUploadImageCell

@interface BKUploadImageCell()
///
@property (nonatomic, strong) UIButton *deleteBtn;
///
@property (nonatomic, strong) BKProgressBarView *progressBarView;
@end

@implementation BKUploadImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self addGesture];
    }
    return self;
}

#pragma mark - UI
- (void)initSubViews {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    
    _deleteBtn = [[UIButton alloc] init];
    [_deleteBtn setImage:[UIImage imageNamed:@"deleteimage"] forState:UIControlStateNormal];
    _deleteBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    [self.contentView bringSubviewToFront:_deleteBtn];
    
    if (_progressBarView == nil) {
//        _progressBarView = [[BKProgressBarView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 5, self.frame.size.width, 5) type:progressBar];
        _progressBarView = [[BKProgressBarView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.5, self.frame.size.width * 0.5) type:tankFormProgressBar];
        _progressBarView.center = self.contentView.center;
    }
    // 进度条背景颜色
    _progressBarView.progressBarBGC = [UIColor clearColor];
    // 下载进度条颜色
    _progressBarView.fillColor = [UIColor colorWithWhite:1 alpha:0.7];
    // 边框颜色
    _progressBarView.strokeColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self addSubview:_progressBarView];
    _progressBarView.hidden = YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
    _deleteBtn.frame = CGRectMake(self.contentView.frame.size.width - 15, 0, 15, 15);
}

- (void)addGesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    longPress.minimumPressDuration = 1;
    [self addGestureRecognizer:longPress];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9) {
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        [self addGestureRecognizer:panGes];
    }
}

#pragma mark - setter

- (void)setModel:(BKUploadImageModel *)model{
    _model = model;
    _imageView.image = [self imageCompressForWidth:model.image targetWidth:self.contentView.frame.size.width];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _progressBarView.hidden = NO;
    _progressBarView.loadingProgress = progress;
    if (progress == 1) {
        _progressBarView.hidden = YES;
    }
}

#pragma mark - event

- (void)deleteBtnClick:(UIButton *)sender {
    if (_didUploadImageDeleteHandler) {
        _didUploadImageDeleteHandler(self.model,self);
    }
}

- (void)gestureAction:(UIGestureRecognizer *)ges {
    if (_cellGestureHandler) {
        _cellGestureHandler(self.model,ges);
    }
}

#pragma mark - util

- (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
