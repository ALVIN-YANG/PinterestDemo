//
//  PhotoItem.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoItem : NSObject
/**
 *  宽
 */
@property (nonatomic, assign) NSNumber *width;
/**
 *  高
 */
@property (nonatomic, copy) NSNumber *height;
/**
 *  图片路径
 */
@property (nonatomic, copy) NSString *path;
@end
