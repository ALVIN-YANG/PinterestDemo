//
//  MagicMoveTransition.m
//  缩放转场效果
//
//  Created by 杨卢青 on 16/5/29.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "MagicMoveTransition.h"
#import "PinBoardViewController.h"
#import "PinBoardDetailViewController.h"
#import "PinBoardCollectionViewCell.h"
#import "PinDetailViewCell.h"
#import "CellDetailModel.h"

@implementation MagicMoveTransition

#pragma mark - UIViewControllerAnimatedTransitioning
//返回转场时间
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

//该方法是定义两个 ViewController 之间过渡效果的地方。这个方法会传递给我们一个参数transitionContext，该参数可以让我们访问一些实现过渡所必须的对象。
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //获取两个VC 和 动画发生的容器
    PinBoardViewController *fromVC = (PinBoardViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    PinBoardDetailViewController *toVC = (PinBoardDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //对选中Cell上的 imageView 截图, 同时隐藏
    PinBoardCollectionViewCell *cell = (PinBoardCollectionViewCell *)[fromVC.collectionView cellForItemAtIndexPath:[[fromVC.collectionView indexPathsForSelectedItems] firstObject]];
    fromVC.indexPath = [[fromVC.collectionView indexPathsForSelectedItems] firstObject];
    
    
    UIView *snapShotView = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = fromVC.finalCellRect = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    cell.imageView.hidden = YES;
    
  
    //获取toVC中图片的位置
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    //此时的Cell还不能被创建, 只能从数据中得到frame
    //求更好的解决办法 😭
    CellDetailModel *model = toVC.itemArray[toVC.indexPath.row];
    CGFloat scale = ([UIScreen mainScreen].bounds.size.width - 40) / [model.photo.width floatValue];
    CGRect finalRect = CGRectMake(20, 64, [model.photo.width floatValue] * scale, [model.photo.height floatValue] * scale);
    
    toVC.view.alpha = 0;
    
    
    //把动画前后的两个ViewController加到容器中, 顺序很重要,
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    
    
    //此句会让detailCell 加载判定一次隐藏imageview
    //😭为什么CollectionView reloadData不行啊 😭
    [containerView layoutIfNeeded];
    
    //动起来 第二个控制器的透明度0~1; 让截图SnapShotView的位置更新到最新;
    /**
     transitionDuration : 持续时间
     delay : 延迟
     usingSpringWithDamping : 弹簧效果幅度(数值越小震动越明显)
     initialSpringVelocity : 初始速度
     options : 动画过度效果
     */
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:2.0f options:UIViewAnimationOptionTransitionNone animations:^{
        
        toVC.view.alpha = 1.0;
        snapShotView.frame = finalRect;
        
    } completion:^(BOOL finished) {
        //为了让回来的时候, cell上的图片显示, 必须要让cell上的图片显示出来
        cell.imageView.hidden = NO;
        [snapShotView removeFromSuperview];
        
        //这句 会让 重新加载cell 判定imageview的显示
        [toVC.collectionView reloadData];
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end
