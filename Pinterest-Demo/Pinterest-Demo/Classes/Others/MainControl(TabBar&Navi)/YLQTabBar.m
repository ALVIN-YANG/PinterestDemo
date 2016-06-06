//
//  YLQTabBar.m
//  Sesame
//
//  Created by 杨卢青 on 16/3/8.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "YLQTabBar.h"
#import "LQMacro.h"

@interface YLQTabBar()

@property (nonatomic, assign)NSInteger previousClickedTabBarButtonTag;
@end
@implementation YLQTabBar


- (void)layoutSubviews{
    [super layoutSubviews];

    //遍历所有子控件
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

}

#pragma mark - tabBarButtonClick
- (void)tabBarButtonClick:(UIControl *)tabBarButton{
    if (self.previousClickedTabBarButtonTag == tabBarButton.tag) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:YLQTabBarButtonDidRepeatClickNotification object:nil];
    }
    self.previousClickedTabBarButtonTag = tabBarButton.tag;
    
}
@end
