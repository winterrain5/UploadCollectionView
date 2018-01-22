//
//  BKSystemCameraPhotoTool.h
//  BKUploadCollectionView
//
//  Created by Derrick on 2018/1/19.
//  Copyright © 2018年 bike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^cameraReturn)(UIImage *image,NSString *videoPath);

@interface BKSystemCameraPhotoTool : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 *  单例
 *
 *  @return VDCameraAndPhotoTool对象
 */
+ (instancetype)shareInstance;
/**
 *  调用系统相机录像
 *
 *  @param vc         要调用相机的控制器
 *  @param finishBack 录像完成的回调
 */
- (void)showVideoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack;
/**
 *  调用系统相机
 *
 *  @param vc         要调用相机的控制器
 *  @param finishBack 拍照完成的回调
 */
- (void)showCameraInViewController:(UIViewController *)vc  andFinishBack:(cameraReturn)finishBack;
/**
 *  调用系统相机
 *
 *  @param vc         要调用相机的控制器
 *  @param isNeedEdit 是否需要编辑图片
 *  @param finishBack 拍照完成的回调
 */
- (void)showCameraInViewController:(UIViewController *)vc isNeedEdit:(BOOL)isNeedEdit andFinishBack:(cameraReturn)finishBack;
/**
 *  调用系统相册
 *
 *  @param vc         要调用相册的控制器
 *  @param finishBack 选择完成的回调
 */
- (void)showPhotoInViewController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack;
/**
 *  调用系统相册
 *
 *  @param vc         要调用相册的控制器
 *  @param isNeedEdit 是否需要编辑图片
 *  @param finishBack 选择完成的回调
 */
- (void)showPhotoInViewController:(UIViewController *)vc isNeedEdit:(BOOL)isNeedEdit  andFinishBack:(cameraReturn)finishBack;
/**
 *  显示相机、录像或相册（弹出alert）
 *
 *  @param vc        控制器
 *  @param finishBack 完成回掉
 */
- (void)showImagePickerController:(UIViewController *)vc andFinishBack:(cameraReturn)finishBack;
@end

