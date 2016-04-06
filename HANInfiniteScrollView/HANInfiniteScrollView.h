//
//  HANInfiniteScrollView.h
//  ScrollVIew无限滚动
//
//  Created by 韩燕辉 on 16/4/6.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    HANInfiniteScrollViewDirectionHorizontal = 0,
    HANInfiniteScrollViewDirectionVertical
}HANInfiniteScrollViewDirection;
@class HANInfiniteScrollView;
@protocol HANInfiniteScrollViewDelegate <NSObject>

- (void)infiniteScrollView:(HANInfiniteScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface HANInfiniteScrollView : UIView
//保存图片的数据
@property(nonatomic,strong)NSArray *images;
//滚动方向
@property(nonatomic,assign)HANInfiniteScrollViewDirection direction;
//显示页码
@property(nonatomic,weak,readonly)UIPageControl *pageControl;

@property(nonatomic,weak)id<HANInfiniteScrollViewDelegate> delegate;
@end
