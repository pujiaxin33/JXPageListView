//
//  NormalRecommendListView.m
//  JXPageListView
//
//  Created by jiaxin on 2018/9/17.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "NormalRecommendListView.h"
#import "JXCategoryView.h"
#import "TestListBaseView.h"
#import "UIWindow+JXSafeArea.h"

@interface NormalRecommendListView()
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation NormalRecommendListView

- (instancetype)init
{
    self = [super init];
    if (self) {

        CGFloat naviHeight = [UIApplication.sharedApplication.keyWindow jx_navigationHeight];

        NSUInteger count = 3;
        CGFloat categoryViewHeight = 50;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height - naviHeight - categoryViewHeight;

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, categoryViewHeight, width, height)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(width*count, height);
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];

        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        TestListBaseView *powerListView = [[TestListBaseView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        powerListView.isFirstLoaded = YES;
        powerListView.dataSource = @[@"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮", @"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮"].mutableCopy;
        [self.scrollView addSubview:powerListView];

        TestListBaseView *hobbyListView = [[TestListBaseView alloc] initWithFrame:CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        hobbyListView.isFirstLoaded = YES;
        hobbyListView.dataSource = @[@"吃烤肉", @"吃鸡腿肉", @"吃牛肉", @"各种肉"].mutableCopy;
        [self.scrollView addSubview:hobbyListView];

        TestListBaseView *partnerListView = [[TestListBaseView alloc] initWithFrame:CGRectMake(self.scrollView.bounds.size.width*2, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        partnerListView.isFirstLoaded = YES;
        partnerListView.dataSource = @[@"【剑士】罗罗诺亚·索隆", @"【航海士】娜美", @"【狙击手】乌索普", @"【厨师】香吉士", @"【船医】托尼托尼·乔巴", @"【船匠】 弗兰奇", @"【音乐家】布鲁克", @"【考古学家】妮可·罗宾"].mutableCopy;
        [self.scrollView addSubview:partnerListView];

        self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, categoryViewHeight)];
        self.categoryView.backgroundColor = [UIColor whiteColor];
        self.categoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
        self.categoryView.titleColor = [UIColor blackColor];
        self.categoryView.titleColorGradientEnabled = YES;
        self.categoryView.titleLabelZoomEnabled = YES;
        self.categoryView.titles = @[@"能力", @"爱好", @"队友"];

        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineViewColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
        lineView.indicatorLineWidth = 30;
        self.categoryView.indicators = @[lineView];

        self.categoryView.contentScrollView = self.scrollView;
        [self addSubview:self.categoryView];

        //添加分割线，这个完全自己配置
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, categoryViewHeight - 1, width, 1)];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        [self.categoryView addSubview:separatorView];
    }
    return self;
}

@end
