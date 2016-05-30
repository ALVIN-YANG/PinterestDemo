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
    
    //设置第二个控制器的位置, 透明度
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toVC.photoImageView.hidden = YES;
    
    //把动画前后的两个ViewController加到容器中, 顺序很重要, snapShotView在上方
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapShotView];
    
    //动起来 第二个控制器的透明度0~1; 让截图SnapShotView的位置更新到最新;
    /**
     transitionDuration : 持续时间
     delay : 延迟
     usingSpringWithDamping : 弹簧效果幅度(数值越小震动越明显)
     initialSpringVelocity : 初始速度
     options : 动画过度效果
     */
     [containerView layoutIfNeeded];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:2.0f options:UIViewAnimationOptionTransitionNone animations:^{
        
        toVC.view.alpha = 1.0;
        
        //frame是相对于父控件, 所以superView
        snapShotView.frame = [containerView convertRect:toVC.photoImageView.frame fromView:toVC.photoImageView.superview];
       
    } completion:^(BOOL finished) {
        //为了让回来的时候, cell上的图片显示, 必须要让cell上的图片显示出来
        toVC.photoImageView.hidden = NO;
        cell.imageView.hidden = NO;
        [snapShotView removeFromSuperview];
        
        //告诉系统动画结束
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end
