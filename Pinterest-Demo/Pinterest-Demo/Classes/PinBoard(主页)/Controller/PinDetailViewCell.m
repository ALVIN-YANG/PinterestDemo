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

@implementation PinDetailViewCell

- (void)setItem:(CellDetailModel *)item
{
    _item = item;
    self.detailImageView.backgroundColor = YLQRandomColor;
    
    self.imageHeightConstraint.constant = ([UIScreen mainScreen].bounds.size.width - 40) / [_item.photo.width floatValue] * [_item.photo.height floatValue];
    
    NSArray *array = [_item.photo.path componentsSeparatedByString:@"_webp"];
    [_detailImageView pin_setImageFromURL:[NSURL URLWithString:array[0]]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)backButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backToPinBoardViewControllerWithIndex:)]) {
        [self.delegate backToPinBoardViewControllerWithIndex:_indexPath];
    }
}

@end
