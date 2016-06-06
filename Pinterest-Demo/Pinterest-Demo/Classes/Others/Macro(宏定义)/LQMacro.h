//
//  LQMacro.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//
@import UIKit;
@import Foundation;
#ifndef LQMacro_h
#define LQMacro_h

//颜色
#define Color(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1];
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

#define YLQRandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//字符串
#define YLQTabBarButtonDidRepeatClickNotification @"YLQTabBarButtonDidRepeatClickNotification"

/*自定义Log*/
// 调试
#ifdef DEBUG
#define YLQLog(...) NSLog(__VA_ARGS__)
#else
// 发布
#define YLQLog(...)
#endif

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define LQBaseUrl  @"http://203.80.144.213/napi/index/hot/?platform_name=iPhone%20OS&__domain=www.duitang.com&include_fields=sender%2Cfavroite_count%2Calbum%2Cicon_url%2Creply_count%2Clike_count&app_version=6.0.7%20rv%3A158667&device_platform=iPhone8%2C1&locale=zh_CN&app_code=gandalf&platform_version=9.3.2&screen_height=667&device_name=Unknown%20iPhone&limit=0&screen_width=375"

#define LQDetailURL @"http://203.80.144.212/napi/blog/detail/?platform_name=iPhone%20OS&__domain=www.duitang.com&include_fields=tags%2Crelated_albums%2Crelated_albums.covers%2Croot_album%2Cshare_links_2%2Cextra_html%2Ctop_comments%2Ctop_like_users&app_version=6.0.7%20rv%3A158667&device_platform=iPhone8%2C1&top_like_users_count=8&locale=zh_CN&app_code=gandalf&platform_version=9.3.2&screen_height=667&top_forward_users_count=8&device_name=Unknown%20iPhone&screen_width=375&top_comments_count=12"

//blog_id=580578475
//http://203.80.144.212/napi/blog/detail/?platform_name=iPhone%20OS&__domain=www.duitang.com&include_fields=tags%2Crelated_albums%2Crelated_albums.covers%2Croot_album%2Cshare_links_2%2Cextra_html%2Ctop_comments%2Ctop_like_users&app_version=6.0.7%20rv%3A158667&device_platform=iPhone8%2C1&top_like_users_count=8&locale=zh_CN&app_code=gandalf&platform_version=9.3.2&screen_height=667&top_forward_users_count=8&device_name=Unknown%20iPhone&screen_width=375&top_comments_count=12&blog_id=579488118
//579488118
#endif /* LQMacro_h */
