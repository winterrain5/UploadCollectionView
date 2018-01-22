//
//  BKUploadImageModel.h
//  BKUploadCollectionView
//
//  Created by Derrick on 2018/1/19.
//  Copyright © 2018年 bike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BKUploadImageModel:NSObject
///
@property (nonatomic, strong) UIImage *image;
///
@property (nonatomic, assign,getter=isAdd) BOOL add;
@end
