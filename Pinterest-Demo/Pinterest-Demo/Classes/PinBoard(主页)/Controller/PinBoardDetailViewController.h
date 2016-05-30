//
//  PinBoardDetailViewController.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/30.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDetailModel.h"

@interface PinBoardDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *imageHCons;

@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, copy) NSString *imageURL;

@property (nonatomic, strong) CellDetailModel *model;
@end
