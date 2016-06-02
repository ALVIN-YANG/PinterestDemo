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

#import "PinDetailViewCell.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <PINRemoteImage/PINImageView+PINRemoteImage.h>
#import <PINCache/PINCache.h>
#import "LQMacro.h"

@interface PinBoardDetailViewController ()<UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PinDetailViewCellDelegate, PinBoardViewControllerDelegate>

//请求管理者
@property (nonatomic, strong) AFHTTPSessionManager *mgr;


@end

@implementation PinBoardDetailViewController

static NSString * const Identifier = @"PinDetailViewCell";

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
   
}

#pragma mark - life Cycle
- (void)loadView
{
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self setupCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"shuaxin" object:nil];
}

-(void)notificationAction:(NSNotification *)notification{
    NSMutableArray *itemArray = [notification.userInfo objectForKey:@"itemArray"];
    _itemArray = itemArray;
    NSLog(@"itemarray.count:%ld", itemArray.count);
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.delegate = self;
}

#pragma mark - Helpers
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (void)setupCollectionView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PinDetailViewCell class]) bundle:nil] forCellWithReuseIdentifier:Identifier];

    //定位到相应页面
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    NSLog(@"detailVC.indexPath:%ld", self.indexPath.row);

}

#pragma mark - PinDetailViewCellDelegate
- (void)backToPinBoardViewControllerWithIndex:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if ([self.delegate respondsToSelector:@selector(backHomeWithIndexPath:)]) {
        [self.delegate backHomeWithIndexPath:indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PinBoardViewControllerDelegate
- (void)refreshDetailViewWithData:(NSMutableArray *)itemArray
{
    _itemArray = itemArray;
    [self.collectionView reloadData];
    NSLog(@"itemArray.count:%ld", _itemArray.count);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PinDetailViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    CellDetailModel *item = _itemArray[indexPath.row];
    cell.item = item;
    cell.delegate = self;
    
    if (self.view.alpha < 1.0) {
        cell.detailImageView.hidden = YES;
    } else {
        cell.detailImageView.hidden = NO;
    }
 
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //压栈, first是最后一个
    NSIndexPath *visibleIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    
    if (visibleIndexPath.row == (_itemArray.count - 2)) {
        if ([self.delegate respondsToSelector:@selector(needMoreDataFromYou)]) {
            [self.delegate needMoreDataFromYou];
        }
    }
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
