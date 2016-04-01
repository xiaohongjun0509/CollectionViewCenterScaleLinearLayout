//
//  CenterScaleLinearLayout.m
//  CollectionViewCenterScaleLinearLayout
//
//  Created by hongjunxiao on 16/3/31.
//  Copyright © 2016年 ihj. All rights reserved.
//

#import "CenterScaleLinearLayout.h"
/**
 *  实现了：
 */
@implementation CenterScaleLinearLayout


- (instancetype)init{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
//  让第一个item居中显示, 所以给他一个inset。
    self.sectionInset = UIEdgeInsetsMake(0, (self.collectionView.bounds.size.width - self.itemSize.width) * 0.5, 0, (self.collectionView.bounds.size.width - self.itemSize.width) * 0.5);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    CGFloat currentX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *atts in array) {
        CGFloat scaleX = 1 - ABS(atts.center.x - currentX) / self.collectionView.bounds.size.width;
        if (scaleX < 0.7) {
            scaleX = 0.7;
        }
//        NSLog(@"%f",scaleX);
        atts.transform = CGAffineTransformMakeScale(scaleX, scaleX);
    }
    return array;
}


/**
 *  停止滚动时候的目标偏移量
 *
 *  @param proposedContentOffset 按照当前的速度，系统计算出来的目标偏移量
 *
 *  @return 每次滚动的时候都让最近的item进行居中时的偏移量
 */

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
//算出要显示的范围
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    
    CGFloat currentX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width * 0.5;
    CGFloat miniDelta = MAXFLOAT;
//  根据父类算出矩属性数组
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *atts in array) {
        if (ABS(atts.center.x - currentX) < ABS(miniDelta)) {
            miniDelta = atts.center.x - currentX;
        }
    }
    return CGPointMake(proposedContentOffset.x + miniDelta, 0);
    

}
@end
