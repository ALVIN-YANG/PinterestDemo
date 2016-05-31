//
//  PinBoardDetailViewController.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/30.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDetailModel.h"

@protocol PinBoardDetailViewControllerDelegate <NSObject>

- (void)backHomeWithIndexPath:(NSIndexPath *)indexPath;

- (void)needMoreDataFromYou;
@end

@interface PinBoardDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CellDetailModel *model;

@property (nonatomic, assign) NSInteger nowIndex;
@property (nonatomic, strong) NSMutableArray *itemArray;


@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CGRect finalCellRect;

@property (nonatomic, weak) id <PinBoardDetailViewControllerDelegate> delegate;
@end
