//
//  PinBoardDetailViewController.m
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/30.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "PinBoardDetailViewController.h"
#import "PinBoardViewController.h"
#import "MagicMoveInverseTransition.h"
#import "DetailPageModel.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <PINRemoteImage/PINImageView+PINRemoteImage.h>
#import <PINCache/PINCache.h>
#import "LQMacro.h"

@interface PinBoardDetailViewController ()<UINavigationControllerDelegate>

//请求管理者
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
//数据:模型数组
@property (nonatomic, strong) NSArray *itemArray;


@end

@implementation PinBoardDetailViewController

#pragma mark - init

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}

- (void)setModel:(CellDetailModel *)model
{
    _model = model;
   
    
//
//    CGFloat imageH = (self.view.bounds.size.width - 40) / [model.photo.width floatValue] * [model.photo.height floatValue];
//    self.imageHeightConstraint.constant = imageH;
//    [self.view layoutIfNeeded];
    
    //取消加载
//    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    //拼接parameter
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"blog_id"] = model.id;
//    [self.mgr GET:LQDetailURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [responseObject writeToFile:@"/Users/YLQ/Desktop/Pinterest-Demo/DetailData.plist" atomically:YES];
//        
//        //        DetailPageModel *topModel = [DetailPageModel mj_objectWithKeyValues:responseObject];
//        
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败");
//    }];
}

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.photoImageView.backgroundColor = YLQRandomColor;
    
    self.imageHeightConstraint.constant = (self.view.bounds.size.width - 40) / [_model.photo.width floatValue] * [_model.photo.height floatValue];
    
    NSArray *array = [_model.photo.path componentsSeparatedByString:@"_webp"];
    [_photoImageView pin_setImageFromURL:[NSURL URLWithString:array[0]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[PinBoardViewController class]]) {
        MagicMoveInverseTransition *interseTransition = [[MagicMoveInverseTransition alloc] init];
        return interseTransition;
    }
    else {
        return nil;
    }
}


@end
