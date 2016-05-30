//
//  DetailPageModel.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/30.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SenderItem.h"
#import "PhotoItem.h"

@interface DetailPageModel : NSObject

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
@end
