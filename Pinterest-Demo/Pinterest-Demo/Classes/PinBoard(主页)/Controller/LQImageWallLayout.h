//
//  ImageWallLayout.h
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageWallLayoutDelegate <NSObject>
//返回Item高度
@required
- (CGFloat)collectionView:(UICollectionView *)collectionView Layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface ImageWallLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat columnWidth;
@property (nonatomic, assign) BOOL orientationIsLandscape;
@property (nonatomic, assign) BOOL isiPhone;

@property (weak, nonatomic) id <ImageWallLayoutDelegate> delegate;

- (void)resetFrames;
@end
