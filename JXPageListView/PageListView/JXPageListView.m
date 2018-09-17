//
//  JXPageView.m
//
//  Created by jiaxin on 2018/9/13.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "JXPageListView.h"
#import "JXPageListContainerView.h"

static NSString *const kListContainerCellIdentifier = @"jx_kListContainerCellIdentifier";

@interface JXPageListView () <JXPageListContainerViewDelegate, JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *pinCategoryView;
@property (nonatomic, weak) id<JXPageListViewDelegate> delegate;
@property (nonatomic, strong) JXPageListMainTableView *mainTableView;
@property (nonatomic, strong) JXPageListContainerView *listContainerView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;
@property (nonatomic, strong) UITableViewCell *listContainerCell;
@property (nonatomic, assign) BOOL isCellConfiged;
@end

@implementation JXPageListView

- (instancetype)initWithDelegate:(id<JXPageListViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    _isSaveListViewScrollState = YES;

    self.pinCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
    self.pinCategoryView.backgroundColor = [UIColor whiteColor];
    self.pinCategoryView.delegate = self;
    self.pinCategoryView.titleSelectedColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    self.pinCategoryView.titleColor = [UIColor blackColor];
    self.pinCategoryView.titleColorGradientEnabled = YES;
    self.pinCategoryView.titleLabelZoomEnabled = YES;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor colorWithRed:105/255.0 green:144/255.0 blue:239/255.0 alpha:1];
    lineView.indicatorLineWidth = 30;
    self.pinCategoryView.indicators = @[lineView];
    
    _mainTableView = [[JXPageListMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [UIView new];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kListContainerCellIdentifier];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.mainTableView];

    _listContainerView = [[JXPageListContainerView alloc] initWithDelegate:self];
    self.listContainerView.mainTableView = self.mainTableView;

    self.pinCategoryView.contentScrollView = self.listContainerView.collectionView;

    [self configListViewDidScrollCallback];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.mainTableView.frame = self.bounds;
}

- (void)reloadData {
    [self configListViewDidScrollCallback];
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
}

- (CGFloat)getListContainerCellHeight {
    return self.bounds.size.height;
}

- (UITableViewCell *)configListContainerCellAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isCellConfiged) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //触发第一个列表的下拉刷新
            NSArray *listViews = [self.delegate listViewsInPageListView:self];
            if (listViews.count > 0) {
                [listViews[0] listViewLoadDataIfNeeded];
            }
        });
        self.isCellConfiged = YES;
    }

    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:kListContainerCellIdentifier forIndexPath:indexPath];
    self.listContainerCell = cell;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

    self.pinCategoryView.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width, self.pinCategoryViewHeight);
    if (self.pinCategoryView.superview == nil) {
        //首次使用pinCategoryView的时候，把pinCategoryView添加到它上面。
        [cell.contentView addSubview:self.pinCategoryView];
    }

    self.listContainerView.frame = CGRectMake(0, self.pinCategoryViewHeight, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height - self.pinCategoryViewHeight);
    [cell.contentView addSubview:self.listContainerView];

    return cell;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    //处理当页面滚动在最底部pageView的时候，页面需要立即停住，没有回弹效果。给用户一种切换到pageView浏览模式了
    if (scrollView.contentOffset.y > 10) {
        scrollView.bounces = NO;
    }else {
        scrollView.bounces = YES;
    }

    CGFloat topContentY = [self getTopContentHeight];
    if (scrollView.contentOffset.y >= topContentY) {
        //当滚动的contentOffset.y大于了指定sectionHeader的y值，且还没有被添加到self.view上的时候，就需要切换superView
        if (self.pinCategoryView.superview != self) {
            [self addSubview:self.pinCategoryView];
        }
    }else if (self.pinCategoryView.superview != self.listContainerCell.contentView) {
        //当滚动的contentOffset.y小于了指定sectionHeader的y值，且还没有被添加到sectionCategoryHeaderView上的时候，就需要切换superView
        [self.listContainerCell.contentView addSubview:self.pinCategoryView];
    }

    if (scrollView.isTracking || scrollView.isDecelerating) {
        //用户滚动的才处理
        if (self.currentScrollingListView != nil && self.currentScrollingListView.contentOffset.y > 0) {
            //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
            self.mainTableView.contentOffset = CGPointMake(0, [self getTopContentHeight]);
        }
    }

    if (!self.isSaveListViewScrollState) {
        if (scrollView.contentOffset.y < topContentY) {
            //mainTableView已经显示了header，listView的contentOffset需要重置
            NSArray *listViews = [self.delegate listViewsInPageListView:self];
            CGFloat insetTop = scrollView.contentInset.top;
            if (@available(iOS 11.0, *)) {
                insetTop = scrollView.adjustedContentInset.top;
            }
            for (UIView <JXPageListViewListDelegate>* listView in listViews) {
                [listView listScrollView].contentOffset = CGPointMake(0, -insetTop);
            }
        }
    }
}


#pragma mark - Private

- (void)configListViewDidScrollCallback {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    for (UIView <JXPageListViewListDelegate>* listView in listViews) {
        __weak typeof(self)weakSelf = self;
        [listView listViewDidScrollCallback:^(UIScrollView *scrollView) {
            [weakSelf listViewDidScroll:scrollView];
        }];
    }
}


- (void)listViewDidSelectedAtIndex:(NSInteger)index {
    UIView<JXPageListViewListDelegate> *listContainerView = [self.delegate listViewsInPageListView:self][index];
    if ([listContainerView listScrollView].contentOffset.y > 0) {
        //当前列表视图已经滚动显示了内容
        [self showListContainerCell];
    }
}

/**
 获取除去底部listContainerCell之外，上面所有内容的高度

 @return 高度
 */
- (CGFloat)getTopContentHeight {
    return self.mainTableView.contentSize.height - self.bounds.size.height;
}

- (void)showListContainerCell {
    CGFloat maxY = [self getTopContentHeight];
    [self.mainTableView setContentOffset:CGPointMake(0, maxY) animated:YES];
}

- (void)listViewDidScroll:(UIScrollView *)scrollView {
    self.currentScrollingListView = scrollView;

    if (scrollView.isTracking == NO && scrollView.isDecelerating == NO) {
        return;
    }

    CGFloat topContentHeight = [self getTopContentHeight];
    if (self.mainTableView.contentOffset.y < topContentHeight) {
        //mainTableView的header还没有消失，让listScrollView固定
        CGFloat insetTop = scrollView.contentInset.top;
        if (@available(iOS 11.0, *)) {
            insetTop = scrollView.adjustedContentInset.top;
        }
        scrollView.contentOffset = CGPointMake(0, -insetTop);
        scrollView.showsVerticalScrollIndicator = NO;
    }else {
        //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
        self.mainTableView.contentOffset = CGPointMake(0, topContentHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

#pragma mark - JXPagingListContainerViewDelegate

- (NSInteger)numberOfRowsInListContainerView:(JXPageListContainerView *)listContainerView {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    return listViews.count;
}

- (UIView *)listContainerView:(JXPageListContainerView *)listContainerView listViewInRow:(NSInteger)row {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    return listViews[row];
}

- (void)listContainerView:(JXPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    self.currentScrollingListView = [listViews[row] listScrollView];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pinCategoryView:didSelectedItemAtIndex:)]) {
        [self.delegate pinCategoryView:categoryView didSelectedItemAtIndex:index];
    }
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    [listViews[index] listViewLoadDataIfNeeded];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    //点击选中，会立马回调该方法。但是page还在左右切换。所以延迟0.25秒等左右切换结束再处理。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self listViewDidSelectedAtIndex:index];
    });
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    [self listViewDidSelectedAtIndex:index];
}

@end
