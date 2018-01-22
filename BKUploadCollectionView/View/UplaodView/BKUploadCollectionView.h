//
//  BKUploadCollectionView.h
//  BKUploadCollectionView
//
//  Created by Derrick on 2018/1/18.
//  Copyright © 2018年 bike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKUploadImageModel.h"
@interface BKUploadCollectionView : UIView

- (instancetype)initWithSuperVc:(UIViewController *)vc;
/// 获取总的高度
- (CGFloat)getAllHeight;
/// 获取所有的图片
- (NSArray<UIImage *> *)getAllImageModels;
///
- (void)setImageProgress:(UIImage *)image progress:(CGFloat)progress;
@end



@interface BKUploadFlowLayout: UICollectionViewFlowLayout

@end
