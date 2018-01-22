//
//  ViewController.m
//  BKUploadCollectionView
//
//  Created by Derrick on 2018/1/18.
//  Copyright © 2018年 bike. All rights reserved.
//

#import "ViewController.h"
#import "BKUploadCollectionView.h"

@interface ViewController ()
///
@property (nonatomic, strong) BKUploadCollectionView *uploadView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _uploadView = [[BKUploadCollectionView alloc] initWithSuperVc:self];
    [self.view addSubview:_uploadView];
}


- (IBAction)baritemClick:(id)sender {
    NSArray *imgs = [_uploadView getAllImageModels];
    for (UIImage *image in imgs) {
        [_uploadView setImageProgress:image progress:0.9];
    }
}

@end
