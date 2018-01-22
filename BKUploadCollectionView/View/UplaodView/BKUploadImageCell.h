//
//  CollectionViewCell.h
//  BKUploadCollectionView
//
//  Created by Derrick on 2018/1/19.
//  Copyright © 2018年 bike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BKUploadImageModel;

@interface BKUploadImageCell:UICollectionViewCell
///
@property (nonatomic, strong) UIImageView *imageView;
///
@property (nonatomic, strong) BKUploadImageModel *model;
///
@property (nonatomic, assign) CGFloat progress;
/// 删除block
@property (nonatomic, copy) void (^didUploadImageDeleteHandler)(BKUploadImageModel *model,BKUploadImageCell *cell);
/// 手势block
@property (nonatomic, copy) void (^cellGestureHandler)(BKUploadImageModel *model,UIGestureRecognizer *ges);
@end
