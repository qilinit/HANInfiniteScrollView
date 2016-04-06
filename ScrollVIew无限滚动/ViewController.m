//
//  ViewController.m
//  ScrollVIew无限滚动
//
//  Created by 韩燕辉 on 16/4/6.
//  Copyright © 2016年 hyh. All rights reserved.
//

#import "ViewController.h"
#import "HANInfiniteScrollView.h"

@interface ViewController ()<HANInfiniteScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HANInfiniteScrollView *scrollview = [[HANInfiniteScrollView alloc] init];
    scrollview.frame = CGRectMake(0, 0, 375, 200);
    scrollview.images = @[
                          [UIImage imageNamed:@"image0"],
                          [UIImage imageNamed:@"image1"],
                          [UIImage imageNamed:@"image2"],
                          [UIImage imageNamed:@"image3"]
                          ];
    scrollview.direction = HANInfiniteScrollViewDirectionVertical;
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)infiniteScrollView:(HANInfiniteScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%zd张图片",index);
}
@end
