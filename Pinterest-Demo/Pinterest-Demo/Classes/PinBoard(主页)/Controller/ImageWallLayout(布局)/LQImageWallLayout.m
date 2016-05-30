//
//  ImageWallLayout.m
//  Pinterest-Demo
//
//  Created by 杨卢青 on 16/5/28.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "LQImageWallLayout.h"

@interface LQImageWallLayout()

@property (nonatomic, strong) NSMutableArray *frameArray;
@property (nonatomic, assign) NSInteger numsOfColumns;
@end
@implementation LQImageWallLayout
{
    CGFloat _maxColumnHeight;
}

#pragma mark - init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        return self;
    }
    return nil;
}

- (CGFloat)columnWidth
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (self.orientationIsLandscape) {
        screenWidth = MAX(screenWidth, screenHeight);
    }
    else {
        screenWidth = MIN(screenWidth, screenHeight);
    }
    
    CGFloat colWidth = (screenWidth - (self.numsOfColumns + 1) * self.margin) / self.numsOfColumns;
    
    return colWidth;
}

- (CGFloat)margin
{
    return 10.0;
}

- (NSInteger)numsOfColumns
{
    //iPhone
    if (self.isiPhone) {
        if (self.orientationIsLandscape) {
            return 3;
        }
        return 2;
    }
    //iPad
    if (self.orientationIsLandscape) {
        return 4;
    }
    return 3;
}

- (void)resetFrames
{
    self.frameArray = nil;
}

- (NSMutableArray *)frameArray
{
    if (!_frameArray) {
        _frameArray = [NSMutableArray array];
        _maxColumnHeight = 0;
    }
    return _frameArray;
}
#pragma mark - Helper
/**
 *  ContentSize由最大Y值决定
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, _maxColumnHeight);
}



- (void)prepareLayout
{
    [super prepareLayout];
    
    self.minimumLineSpacing = self.margin;
    self.minimumInteritemSpacing = self.margin;
    
    
   
        //记录每一列的最小Y值
        NSMutableArray *columHeightList = [NSMutableArray array];
        for (int i = 0; i < self.numsOfColumns; i++) {
            [columHeightList addObject:[NSNumber numberWithFloat:self.margin]];
        }
        
        //布局Item
        for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            CGFloat cellHeight = 0;
            if ([self.delegate respondsToSelector:@selector(collectionView:Layout:heightForItemAtIndexPath:maxHeight:)]) {
                cellHeight = [self.delegate collectionView:self.collectionView Layout:self heightForItemAtIndexPath:cellIndexPath maxHeight:_maxColumnHeight];
            }
            
            CGSize imageSize = CGSizeMake(self.columnWidth, cellHeight);
            
            //把当前Item布置在高度最小的那一列
            NSInteger placementColumn = 0;
            CGFloat lowestHeight = [[columHeightList objectAtIndex:0] floatValue];
            CGFloat tempHeight = 0;
            for (NSInteger k = 0; k < self.numsOfColumns; k++) {
                tempHeight = [[columHeightList objectAtIndex:k] floatValue];
                if (tempHeight < lowestHeight) {
                    lowestHeight = tempHeight;
                    placementColumn = k;
                }
            }
            
            //得到Item的frame, 保存到frameArray
            CGFloat currentXPosition = (self.columnWidth * placementColumn) + (self.margin * (placementColumn + 1));
            CGFloat currentYPosition = lowestHeight;
            
            CGRect currentCellFrame = CGRectMake(currentXPosition, currentYPosition, self.columnWidth, imageSize.height);
            [self.frameArray addObject:[NSValue valueWithCGRect:currentCellFrame]];
            //更新当前列的最大高度
            lowestHeight = lowestHeight + self.margin + imageSize.height;
            [columHeightList replaceObjectAtIndex:placementColumn withObject:[NSNumber numberWithFloat:lowestHeight]];
            
            //用户计算ContentSize, 更新所有列最大高度
            _maxColumnHeight = MAX(_maxColumnHeight, lowestHeight);
        }
    
    NSLog(@"已有数据量:%ld", self.frameArray.count);
    
}

//自定义重写下面方法 告知当前显示的Item的 属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *visibleCellAttributes = [NSMutableArray array];
    
    for (NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:0]; j++) {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:j inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:cellIndexPath];
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {

            [visibleCellAttributes addObject:attributes];
        }
    }
    return visibleCellAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSValue *rectValue = [_frameArray objectAtIndex:indexPath.row];
    
    CGRect cellFrame = [rectValue CGRectValue];
    
    attributes.frame = cellFrame;
    
    return attributes;
}

@end
