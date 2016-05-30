//
//  MagicMoveInverseTransition.m
//  缩放转场效果
//
//  Created by 杨卢青 on 16/5/29.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "MagicMoveInverseTransition.h"
#import "FirstCollectionViewController.h"
#import "SecondViewController.h"
#import "CollectionViewCell.h"


@implementation MagicMoveInverseTransition
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //获取动画前后两个VC 和 发生的容器containerView
    FirstCollectionViewController *toVC = (FirstCollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    SecondViewController *fromVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //在前一个VC上创建一个截图
    UIView *snapShotView = [fromVC.imageViewForSecond snapshotViewAfterScreenUpdates:NO];
    snapShotView.backgroundColor = [UIColor clearColor];
    snapShotView.frame = [containerView convertRect:fromVC.imageViewForSecond.frame fromView:fromVC.view];
    fromVC.imageViewForSecond.hidden = YES;
    
    //初始化fromVC的位置, 滚到fromVC那里就在toVC那里
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    
    //获取toVC中图片的位置
    CollectionViewCell *cell = (CollectionViewCell *)[toVC.collectionView cellForItemAtIndexPath:toVC.indexPath];
    cell.imageView.hidden = YES;
    
    //装到ContainerView 顺序很重要
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:snapShotView];
    
    //执行动画
    /**
     transitionDuration : 持续时间
     delay : 延迟
     usingSpringWithDamping : 弹簧效果幅度(数值越小震动越明显)
     initialSpringVelocity : 初始速度
     options : 动画过度效果
     */
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:2.0f options:UIViewAnimationOptionCurveLinear animations:^{
        fromVC.view.alpha = 0.0f;
        snapShotView.frame = toVC.finalCellRect;
    } completion:^(BOOL finished) {
        [snapShotView removeFromSuperview];
        fromVC.imageViewForSecond.hidden = NO;
        cell.imageView.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
