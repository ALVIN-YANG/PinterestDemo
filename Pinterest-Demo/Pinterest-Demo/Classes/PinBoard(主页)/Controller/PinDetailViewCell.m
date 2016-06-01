//
//  PinDetailViewCell.m
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/30.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "PinDetailViewCell.h"
#import <PINRemoteImage/PINImageView+PINRemoteImage.h>
#import <PINCache/PINCache.h>
#import "LQMacro.h"

@interface PinDetailViewCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topNaviView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewBottomSpaceToSubViewContstrait;

@end

@implementation PinDetailViewCell

- (void)setItem:(CellDetailModel *)item
{
    _item = item;
    self.detailImageView.backgroundColor = YLQRandomColor;
    self.pageLabel.text = [NSString stringWithFormat:@"第%ld页", _indexPath.row];
    self.imageHeightConstraint.constant = ([UIScreen mainScreen].bounds.size.width - 40) / [_item.photo.width floatValue] * [_item.photo.height floatValue];
    
    NSArray *array = [_item.photo.path componentsSeparatedByString:@"_webp"];
    [_detailImageView pin_setImageFromURL:[NSURL URLWithString:array[0]]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configContainView];
}

- (void)configContainView
{
    
        self.containViewBottomSpaceToSubViewContstrait.constant = [UIScreen mainScreen].bounds.size.height - self.imageHeightConstraint.constant - 200;
}

- (IBAction)backButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backToPinBoardViewControllerWithIndex:)]) {
        [self.delegate backToPinBoardViewControllerWithIndex:_indexPath];
    }
}

#pragma mark - ScrollViewDelegate
//下拉跟随
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView && scrollView.contentOffset.y < 0) {
        CGRect topRect = self.topNaviView.frame;
        topRect.origin.y = - scrollView.contentOffset.y;
        self.topNaviView.frame = topRect;
        
    }
}

//滑动返回
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"contentOffset.y : %.2f", self.scrollView.contentOffset.y);
    if (scrollView == self.scrollView && self.scrollView.contentOffset.y < - 50) {
        [self backButtonClick:nil];
    }
}

@end
