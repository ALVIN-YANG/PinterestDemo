//
//  senderItem.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface senderItem : NSObject
/**
 *  icon
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  id
 */
@property (nonatomic, copy) NSNumber *id;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *username;
@end
