//
//  BKUploadCollectionView.m
//  BKUploadCollectionView
//
//  Created by Derrick on 2018/1/18.
//  Copyright © 2018年 bike. All rights reserved.
//


#import "BKUploadCollectionView.h"
#import "BKUploadImageCell.h"
#import "BKUploadAddCell.h"
#import "KSPhotoBrowser.h"
#import "BKSystemCameraPhotoTool.h"
#import <TZImagePickerController/TZImagePickerController.h>

#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenWidth (kScreenBounds.size.width)
#define kScreenHeight (kScreenBounds.size.height)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define margin 12
#define kItemWidth ((kScreenWidth - margin * 5) / 4)

#pragma mark - BKUploadCollectionView

@interface BKUploadCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
///
@property (nonatomic, strong) UICollectionView *collectionView;
///
@property (nonatomic, strong) NSMutableArray<BKUploadImageModel *> *dataSource;
///
@property (nonatomic, strong) UIViewController *vc;
///
@property (nonatomic, strong) UIView *snapShotView;
@property(nonatomic,strong) NSIndexPath * indexPath;
@property(nonatomic,strong) NSIndexPath * nextIndexPath;
@property(nonatomic,weak) BKUploadImageCell * originalCell;

@end

@implementation BKUploadCollectionView

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        BKUploadFlowLayout *layout = [[BKUploadFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[BKUploadImageCell class] forCellWithReuseIdentifier:@"BKUploadImageCell"];
        [_collectionView registerClass:[BKUploadAddCell class] forCellWithReuseIdentifier:@"BKUploadAddCell"];
    }
    return _collectionView;
}

#pragma mark - init


- (void)initSubViews {
    _dataSource = @[].mutableCopy;
    
    BKUploadImageModel *model = [[BKUploadImageModel alloc] init];
    model.add = YES;
    [_dataSource addObject:model];

    [self addSubview:self.collectionView];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BKUploadImageModel *model = self.dataSource[indexPath.item];
    UICollectionViewCell *cell = nil;
    if (model.isAdd) {
        BKUploadAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BKUploadAddCell" forIndexPath:indexPath];
        cell = addCell;
    }else{
        BKUploadImageCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BKUploadImageCell" forIndexPath:indexPath];
        imageCell.model = model;
        __weak __typeof(self)weakSelf = self;
        imageCell.didUploadImageDeleteHandler = ^(BKUploadImageModel *model,BKUploadImageCell *cell) {
            [weakSelf uploadImageDeleteEvent:model];
        };
        imageCell.cellGestureHandler = ^(BKUploadImageModel *model, UIGestureRecognizer *ges) {
            [weakSelf cellGestureWithModel:model ges:ges];
        };
        cell = imageCell;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self selectCellWithModel:self.dataSource[indexPath.item] indexPath:indexPath];
}


-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    id objc = [_dataSource objectAtIndex:sourceIndexPath.item];
    [_dataSource removeObject:objc];
    [_dataSource insertObject:objc atIndex:destinationIndexPath.item];
}



/// 选中cell
- (void)selectCellWithModel:(BKUploadImageModel *)model indexPath:(NSIndexPath *)indexPath{
    
    if (model.isAdd) {
        [self addImage];
    }else{
        [self checkImageWithIndexPath:indexPath];
    }
}

/// 添加cell
- (void)addImage {
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.showSelectBtn = YES;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL finished) {
            
            [self reloadDataSource:photos];
            
        }];
        [self.vc presentViewController:imagePickerVc animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BKSystemCameraPhotoTool *tool = [BKSystemCameraPhotoTool shareInstance];
        [tool showCameraInViewController:self.vc andFinishBack:^(UIImage *image, NSString *videoPath) {
            [self reloadDataSource:@[image]];
        }];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选取照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self.vc presentViewController:alertController animated:YES completion:nil];

}

/// checkImage
- (void)checkImageWithIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < _dataSource.count; i++) {
        BKUploadImageCell *cell = (BKUploadImageCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        BKUploadImageModel *model = _dataSource[i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:cell.imageView image:model.image];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.item];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleNone;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
    [browser showFromViewController:self.vc];

}


/// 删除cell
- (void)uploadImageDeleteEvent:(BKUploadImageModel *)model {
    [self.dataSource removeObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.dataSource indexOfObject:model] inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [self updateFrame];
}

/// 排序
- (void)cellGestureWithModel:(BKUploadImageModel *)model ges:(UIGestureRecognizer *)gestureRecognizer
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >9) {
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:{
                [self beginShakeAnimation];
                //判断手势落点位置是否在路径上
                NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gestureRecognizer locationInView:self.collectionView]];
                if (indexPath == nil) {
                    break;
                }
                //在路径上则开始移动该路径上的cell
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
                break;
            case UIGestureRecognizerStateChanged:
                //移动过程当中随时更新cell位置
                [self.collectionView updateInteractiveMovementTargetPosition:[gestureRecognizer locationInView:self.collectionView]];
                break;
            case UIGestureRecognizerStateEnded:
                [self stopShakeAnimation];
                //移动结束后关闭cell移动
                [self.collectionView endInteractiveMovement];
                break;
            default:
                [self.collectionView cancelInteractiveMovement];
                break;
        }
        
    }else /// 兼容8
    {
        BKUploadImageCell* cell = (BKUploadImageCell*)gestureRecognizer.view;
        static CGPoint startPoint;
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            [self beginShakeAnimation];
            _snapShotView = [cell snapshotViewAfterScreenUpdates:NO];
            _snapShotView.center = cell.center;
            [self.collectionView addSubview:_snapShotView];
            _indexPath = [self.collectionView indexPathForCell:cell];
            _originalCell = cell;
            _originalCell.hidden = YES;
            startPoint = [gestureRecognizer locationInView:self.collectionView];
        }else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
        {
            //获取移动量
            CGFloat tranX = [gestureRecognizer locationOfTouch:0 inView:self.collectionView].x - startPoint.x;
            CGFloat tranY = [gestureRecognizer locationOfTouch:0 inView:self.collectionView].y - startPoint.y;
            
            //进行移动
            _snapShotView.center = CGPointApplyAffineTransform(_snapShotView.center, CGAffineTransformMakeTranslation(tranX, tranY));
            //更新初始位置
            startPoint = [gestureRecognizer locationOfTouch:0 inView:self.collectionView];
            for (UICollectionViewCell *cellVisible in [self.collectionView visibleCells])
            {
                //移动的截图与目标cell的center直线距离
                CGFloat space = sqrtf(pow(_snapShotView.center.x - cellVisible.center.x, 2) + powf(_snapShotView.center.y - cellVisible.center.y, 2));
                //判断是否替换位置，通过直接距离与重合程度
                if (space <= _snapShotView.frame.size.width/2&&(fabs(_snapShotView.center.y-cellVisible.center.y) <= _snapShotView.bounds.size.height/2)) {
                    _nextIndexPath = [self.collectionView indexPathForCell:cellVisible];
                    if (_nextIndexPath.item > _indexPath.item)
                    {
                        for(NSInteger i = _indexPath.item; i <_nextIndexPath.item;i++)
                        {
                            //移动数据源位置
                            [_dataSource exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                    }else
                    {
                        for(NSInteger i = _indexPath.item; i <_nextIndexPath.item;i--)
                        {
                            //移动数据源位置
                            [_dataSource exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                        }
                    }
                    //移动视图cell位置
                    [self.collectionView moveItemAtIndexPath:_indexPath toIndexPath:_nextIndexPath];
                    //更新移动视图的数据
                    _indexPath = _nextIndexPath;
                    break;
                }
            }
        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            [self stopShakeAnimation];
            [_snapShotView removeFromSuperview];
            [_originalCell setHidden:NO];
        }
        
    }
}

- (void)beginShakeAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: -M_1_PI*0.15 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_1_PI*0.15 ];
    rotationAnimation.duration = 0.25;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = INFINITY;
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        if ([cell isKindOfClass:[BKUploadImageCell class]]) {
            [cell.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        }
    }
}

- (void)stopShakeAnimation {
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        if ([cell isKindOfClass:[BKUploadImageCell class]]) {
            [cell.layer removeAnimationForKey:@"rotationAnimation"];
        }
    }
}

/// 刷新数据
- (void)reloadDataSource:(NSArray<UIImage *>*)dataSource{
    
    for (UIImage *imgae in dataSource) {
        BKUploadImageModel *model = [[BKUploadImageModel alloc] init];
        model.image = imgae;
        model.add = NO;
        [_dataSource insertObject:model atIndex:0];
    }
    [self.collectionView reloadData];
    [self updateFrame];
}

/// 更新frame
- (void)updateFrame {
    CGFloat height = (self.dataSource.count % 4  == 0 ? self.dataSource.count / 4 : self.dataSource.count / 4 + 1) * (kItemWidth + margin * 2);
    CGRect tempFrame = CGRectMake(0, (iPhoneX ? 83 : 64) + margin, kScreenWidth, height);
    self.frame = tempFrame;
    self.collectionView.frame = self.bounds;
}

#pragma mark - public method

- (instancetype)initWithSuperVc:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        [self initSubViews];
        _vc = vc;
        self.frame = CGRectMake(0, (iPhoneX ? 83 : 64) + margin, kScreenWidth, kItemWidth + margin * 2);
    }
    return self;
}


- (CGFloat)getAllHeight{
    return self.frame.size.height;
}

- (NSArray<UIImage *> *)getAllImageModels{
    NSMutableArray *tempArray = @[].mutableCopy;
    
    for (BKUploadImageModel *model in self.dataSource) {
        if (model.isAdd) {
            continue;
        }
        [tempArray addObject:model.image];
    }
    return tempArray;
}

- (void)setImageProgress:(UIImage *)image progress:(CGFloat)progress {
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        if ([cell isKindOfClass:[BKUploadImageCell class]]) {
            BKUploadImageCell *imgCell = (BKUploadImageCell *)cell;
            if (imgCell.model.image == image) {
                imgCell.progress = progress;
            }
        }
    }
}
@end




#pragma mark - BKUploadFlowLayout

@implementation BKUploadFlowLayout
- (void)prepareLayout{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    
    self.minimumInteritemSpacing = margin; // item 间距
    self.minimumLineSpacing = margin; // 列间距
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sectionInset = UIEdgeInsetsMake(margin, margin , 0, margin);
}
@end




