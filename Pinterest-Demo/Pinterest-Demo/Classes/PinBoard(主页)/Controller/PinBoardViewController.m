//
//  PinBoardViewController.m
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//
#import "LQMacro.h"
#import "PinBoardViewController.h"
#import "LQImageWallLayout.h"
#import "PinBoardCollectionViewCell.h"
#import "PinBoardDetailViewController.h"

#import "MagicMoveTransition.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import "YLQRefreshFooter.h"
#import "YLQRefreshHeader.h"
#import <PINMemoryCache.h>
//model
#import "TopDataModel.h"
#import "CellDetailModel.h"
#import "SenderItem.h"
#import "PhotoItem.h"

@interface PinBoardViewController ()<ImageWallLayoutDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *_imageArray;
    NSInteger _nextStartIndex;
    CellDetailModel *_model;
}

//请求管理者
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
//数据:模型数组,  不断更新数据, 要可变数组
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation PinBoardViewController

static NSString * const reuseIdentifier = @"PinBoardCell";

#pragma mark - init
- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [AFHTTPSessionManager manager];
    }
    return _mgr;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

#pragma mark - viewCycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self loadData];

    [self setupLayout];
    
    [self setupRefresh];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self;
}

//Segue传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//        PinBoardDetailViewController *secondVC = segue.destinationViewController;
//        secondVC.model = _model;
}

#pragma mark - Helpers

- (void)setupRefresh
{
    self.collectionView.mj_header = [YLQRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.collectionView.mj_footer = [YLQRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

- (void)setupLayout
{
    LQImageWallLayout* customLayout = (LQImageWallLayout*)self.collectionView.collectionViewLayout;
    
    customLayout.delegate = self;
    self.collectionView.delegate = self;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        customLayout.orientationIsLandscape = YES;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        customLayout.isiPhone = YES;
    }
}

- (void)loadData
{
    //取消加载
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    LQImageWallLayout* customLayout = (LQImageWallLayout*)self.collectionView.collectionViewLayout;
    [customLayout resetFrames];
    //拼接parameter
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"start"] = @"0";
    [self.mgr GET:LQBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [responseObject writeToFile:@"/Users/YLQ/Desktop/Pinterest-Demo/HomeData.plist" atomically:YES];
        TopDataModel *topModel = [TopDataModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        _nextStartIndex = topModel.next_start;

        _itemArray = [CellDetailModel mj_objectArrayWithKeyValuesArray:topModel.object_list];
       
        [self.collectionView reloadData];
        //结束刷新
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadNewData
{
    //取消加载
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    LQImageWallLayout* customLayout = (LQImageWallLayout*)self.collectionView.collectionViewLayout;
    [customLayout resetFrames];
    //拼接parameter
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"start"] = [NSString stringWithFormat:@"%ld", _nextStartIndex];
    [self.mgr GET:LQBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [responseObject writeToFile:@"/Users/YLQ/Desktop/Pinterest-Demo/NewHomeData.plist" atomically:YES];
        TopDataModel *topModel = [TopDataModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        _nextStartIndex = topModel.next_start;
        
        [_itemArray addObjectsFromArray:[CellDetailModel mj_objectArrayWithKeyValuesArray:topModel.object_list]];
        NSLog(@"主 数据量:%ld", self.itemArray.count);
        [self.collectionView reloadData];
        //结束刷新
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_footer endRefreshing];
    }];

}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration; {
    
    LQImageWallLayout* customLayout = (LQImageWallLayout*)self.collectionView.collectionViewLayout;
    [customLayout resetFrames];
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        customLayout.orientationIsLandscape = YES;
    }
    else {
        customLayout.orientationIsLandscape = NO;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemArray.count;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PinBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PinCellID" forIndexPath:indexPath];
    
    // Configure the cell
    CellDetailModel *cellModel = _itemArray[indexPath.row];
    cell.item = cellModel;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PinBoardDetailViewController *detailVC = [[UIStoryboard storyboardWithName:NSStringFromClass([PinBoardDetailViewController class]) bundle:nil] instantiateInitialViewController];
    CellDetailModel *cellModel = _itemArray[indexPath.row];
//    PinBoardCollectionViewCell *cell = (PinBoardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    detailVC.photoImageView.image = cell.imageView.image;
    detailVC.model = cellModel;
//    detailVC.imageHCons.constant = (self.view.bounds.size.width - 40) / [cellModel.photo.width floatValue] * [cellModel.photo.height floatValue];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - ImageWallLayoutDelegate
//服务器已经返回图片宽高
- (CGFloat)collectionView:(UICollectionView *)collectionView Layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath maxHeight:(CGFloat)maxHeight
{
    
    LQImageWallLayout *imageWallLayout = (LQImageWallLayout *)collectionViewLayout;
    CellDetailModel *cellModel = _itemArray[indexPath.row];
    CGFloat width = [cellModel.photo.width floatValue];
    CGFloat ratio = imageWallLayout.columnWidth / width;
    CGFloat imageHeight = [cellModel.photo.height floatValue] * ratio;
    
    imageHeight += [cellModel.msg boundingRectWithSize:CGSizeMake(imageWallLayout.columnWidth - 10, 77) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size.height + 10;
    imageHeight += 60;
    return imageHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[PINMemoryCache sharedCache] removeAllObjects];
}

#pragma mark - UINavigationControllerDelegate
//定义转场样式
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[PinBoardDetailViewController class]]) {
        MagicMoveTransition *transition = [[MagicMoveTransition alloc] init];
        return transition;
    }
    else {
        return nil;
    }
}

@end











