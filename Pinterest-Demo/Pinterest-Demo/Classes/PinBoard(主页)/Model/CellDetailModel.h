//
//  CellDetailModel.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SenderItem.h"
#import "PhotoItem.h"

@interface CellDetailModel : NSObject

/**
 *  回复数
 */
@property (nonatomic, assign) NSInteger reply_count;
/**
 *  赞数
 */
@property (nonatomic, assign) NSInteger like_count;
/**
 *  收藏数
 */
@property (nonatomic, assign) NSInteger favorite_count;
/**
 *  msg
 */
@property (nonatomic, copy) NSString *msg;
/**
 *  Sender
 */
@property (nonatomic, strong) SenderItem *sender;
/**
 *  Photo
 */
@property (nonatomic, strong) PhotoItem *photo;
/**
 *  id
 */
@property (nonatomic, copy) NSString *id;
@end
