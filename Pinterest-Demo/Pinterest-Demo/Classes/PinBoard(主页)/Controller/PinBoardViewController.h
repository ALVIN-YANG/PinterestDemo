//
//  PinBoardViewController.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinBoardViewControllerDelegate <NSObject>

- (void)refreshDetailViewWithData:(NSMutableArray *)itemArray;

@end

@interface PinBoardViewController : UICollectionViewController

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CGRect finalCellRect;


@property (nonatomic, weak) id <PinBoardViewControllerDelegate> delegate;
@end
