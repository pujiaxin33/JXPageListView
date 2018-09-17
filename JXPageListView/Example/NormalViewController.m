//
//  NormalViewController.m
//  JXPageListView
//
//  Created by jiaxin on 2018/9/17.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "NormalViewController.h"
#import "JXCategoryView.h"
#import "NormalHotListView.h"
#import "NormalRecommendListView.h"

@interface NormalViewController () <JXCategoryViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NormalHotListView *hotListView;
@property (nonatomic, strong) NormalRecommendListView *recommendListView;
@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"左右分页布局";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;

    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titles = @[@"热门", @"推荐"];

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    lineView.indicatorLineWidth = 30;
    self.categoryView.indicators = @[lineView];

    self.navigationItem.titleView = self.categoryView;

    _scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.scrollView];

    self.hotListView = [[NormalHotListView alloc] init];
    [self.scrollView addSubview:self.hotListView];

    self.recommendListView = [[NormalRecommendListView alloc] init];
    [self.scrollView addSubview:self.recommendListView];

    self.categoryView.contentScrollView = self.scrollView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height);
    self.hotListView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.recommendListView.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}


@end
