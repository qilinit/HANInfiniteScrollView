//
//  HANInfiniteScrollView.m
//  ScrollVIew无限滚动
//
//  Created by 韩燕辉 on 16/4/6.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import "HANInfiniteScrollView.h"
#import <objc/runtime.h>
@interface HANInfiniteScrollView()<UIScrollViewDelegate>
//显示页码
@property(nonatomic,weak)UIPageControl *pageControl;
//显示具体的内容
@property(nonatomic,weak)UIScrollView *scrollView;
//定时器
@property(nonatomic,weak)NSTimer *timer;
@end

@implementation HANInfiniteScrollView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //添加具体内容
        UIScrollView *scrollview = [[UIScrollView alloc] init];
        scrollview.pagingEnabled = YES;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.delegate = self;
        scrollview.bounces = NO;
        [self addSubview:scrollview];
        self.scrollView = scrollview;
        //添加具体内容中的具体图片
        for (NSInteger i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
            [scrollview addSubview:imageView];
        }
        
        //添加页码
        UIPageControl *pageVontrol = [[UIPageControl alloc] init];
        pageVontrol.pageIndicatorTintColor = [UIColor grayColor];
        [pageVontrol setValue:[UIImage imageNamed:@"XMGInfiniteScrollView.bundle/other"] forKey:@"_pageImage"];
        [pageVontrol setValue:[UIImage imageNamed:@"XMGInfiniteScrollView.bundle/current"] forKey:@"_currentPageImage"];
        
        [self addSubview:pageVontrol];
        self.pageControl = pageVontrol;
        
    }
    [self startTimer];
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //整体的尺寸
    CGFloat scrollViewW = self.bounds.size.width;
    CGFloat scrollViewH = self.bounds.size.height;
    //ScrollView
    self.scrollView.frame = self.bounds;
    if (self.direction == HANInfiniteScrollViewDirectionHorizontal) {
        self.scrollView.contentSize = CGSizeMake(3 * scrollViewW, 0);
    } else if(self.direction == HANInfiniteScrollViewDirectionVertical){
        self.scrollView.contentSize = CGSizeMake(0, 3 * scrollViewH);
    }
    
    //UIImageView
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        if (self.direction == HANInfiniteScrollViewDirectionHorizontal) {
            imageView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
        } else if(self.direction == HANInfiniteScrollViewDirectionVertical){
            imageView.frame = CGRectMake(0, i * scrollViewH, scrollViewW, scrollViewH);
        }
        
    }
    //UIPageControl
    CGFloat pageControlW = 130;
    CGFloat pageControlH = 25;
    
    
    self.pageControl.frame = CGRectMake(scrollViewW - pageControlW, scrollViewH - pageControlH, pageControlW, pageControlH);
    //更新内容
    [self updateContent];
    
    
}
- (void)setImages:(NSArray *)images
{
    _images = images;
    self.pageControl.numberOfPages = images.count;
}

//更新内容
- (void)updateContent
{
    //当前的页码
    NSInteger page = self.pageControl.currentPage;
    //更新所有UIImageView的内容
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        //图片的索引
        NSInteger index = 0;
        if (i == 0) {
            index = page - 1;
        } else if(i == 1){
            index = page;
        } else{
            index = page + 1;
        }
        if (index == -1) {
            index = self.images.count - 1;
        } else if(index == self.images.count){
            index = 0;
        }
        imageView.image = self.images[index];
        imageView.tag = index;
    }
    if (self.direction == HANInfiniteScrollViewDirectionHorizontal) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    } else if(self.direction == HANInfiniteScrollViewDirectionVertical){
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);
    }
    
}
#pragma mark 监听
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(infiniteScrollView:didSelectItemAtIndex:)]) {
        [self.delegate infiniteScrollView:self didSelectItemAtIndex:tap.view.tag];
    }
}

#pragma mark 定时器
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage
{
    if (self.direction == HANInfiniteScrollViewDirectionHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.scrollView.frame.size.width, 0) animated:YES];
    }else if(self.direction == HANInfiniteScrollViewDirectionVertical){
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + self.scrollView.frame.size.height) animated:YES];
    }
}

#pragma mark UIScrollViewDelegate
//开始拖动的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}
//拖动的时候开始调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //求出显示在中间的UIImageView
    UIImageView *destImageView = nil;
    CGFloat minDelta = MAXFLOAT;
    CGFloat delta = 0.0;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        if (self.direction == HANInfiniteScrollViewDirectionHorizontal) {
            delta = ABS(self.scrollView.contentOffset.x - imageView.frame.origin.x);
        } else if(self.direction == HANInfiniteScrollViewDirectionVertical){
            delta = ABS(self.scrollView.contentOffset.y - imageView.frame.origin.y);
        }
        if (delta < minDelta) {
            minDelta = delta;
            destImageView = imageView;
        }
    }
    self.pageControl.currentPage = destImageView.tag;
}
//停止拖动的时候开始调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateContent];
    [self startTimer];
}
//通过代码使UIScrollView开始滚动的时候调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateContent];
}

@end
