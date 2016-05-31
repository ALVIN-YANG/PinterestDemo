//
//  PinBoardCollectionViewCell.m
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "PinBoardCollectionViewCell.h"
#import <PINRemoteImage/PINImageView+PINRemoteImage.h>
#import <PINCache/PINCache.h>
#import "LQMacro.h"

//#import <UIImageView+WebCache.h>

@interface PinBoardCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

@end

@implementation PinBoardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius = 7;
}

- (void)setItem:(CellDetailModel *)item
{
    _item = item;
    
    //要把后缀截掉
    NSArray *array = [item.photo.path componentsSeparatedByString:@"_webp"];
    [_imageView setPin_updateWithProgress:YES];
    self.imageView.backgroundColor = YLQRandomColor;
    self.imageView.alpha = 0.0f;
    __weak PinBoardCollectionViewCell *weakCell = self;
    
    [self.imageView pin_setImageFromURL:[NSURL URLWithString:array[0]]
                             completion:^(PINRemoteImageManagerResult *result) {
                                 if (result.requestDuration > 0.25) {
                                     [UIView animateWithDuration:0.3 animations:^{
                                         weakCell.imageView.alpha = 1.0f;
                                     }];
                                 } else {
                                     weakCell.imageView.alpha = 1.0f;
                                 }
                             }];

    self.msgHeightConstraint.constant = (double)[item.msg boundingRectWithSize:CGSizeMake(self.bounds.size.width - 10, 77) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size.height + 10;
    self.msgLabel.preferredMaxLayoutWidth = self.bounds.size.width - 10;
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.msgLabel.text = item.msg;
   
    [self.iconImageView pin_setImageFromURL:[NSURL URLWithString:item.sender.avatar]];
    self.iconImageView.layer.cornerRadius = 13;
    self.iconImageView.clipsToBounds = YES;
    self.userNameLabel.text = item.sender.username;
    
}

@end
