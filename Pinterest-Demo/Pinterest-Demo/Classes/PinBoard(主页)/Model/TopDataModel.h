//
//  TopDataModel.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopDataModel : NSObject
/**
 *  下一个请求开始位置
 */
@property (nonatomic, assign) NSInteger next_start;
/**
 *  数据数组
 */
@property (nonatomic, strong) NSArray *object_list;
@end
