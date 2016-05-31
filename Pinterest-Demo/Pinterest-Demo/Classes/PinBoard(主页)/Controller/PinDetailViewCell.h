//
//  PinDetailViewCell.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/30.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDetailModel.h"

@protocol PinDetailViewCellDelegate <NSObject>

- (void)backToPinBoardViewControllerWithIndex:(NSIndexPath *)indexPath;

@end

@interface PinDetailViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (nonatomic, strong) CellDetailModel *item;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger nowIndex;


@property (nonatomic, weak) id <PinDetailViewCellDelegate> delegate;
@end
