//
//  BKUploadAddCell.m
//  BKUploadCollectionView
//
//  Created by Derrick on 2018/1/19.
//  Copyright © 2018年 bike. All rights reserved.
//

#import "BKUploadAddCell.h"

#pragma mark - BKUploadAddCell

@interface BKUploadAddCell()
///
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation BKUploadAddCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

#pragma mark - UI
- (void)initSubViews {
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"addimage"];
    [self.contentView addSubview:_imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
    
}

@end

