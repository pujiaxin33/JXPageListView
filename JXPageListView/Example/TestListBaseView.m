//
//  TestListBaseView.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TestListBaseView.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface TestListBaseView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@end

@implementation TestListBaseView

- (void)dealloc
{
    self.scrollCallback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.tableView.frame = self.bounds;
}

- (void)setIsNeedHeader:(BOOL)isNeedHeader {
    _isNeedHeader = isNeedHeader;

    __weak typeof(self)weakSelf = self;
    if (self.isNeedHeader) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                if (self.dataSource.count >= 10) {
                    //模拟加载完数据之后添加footer
                    __strong typeof(weakSelf)strongSelf = weakSelf;
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [strongSelf.dataSource addObject:@"加载更多成功"];
                            [strongSelf.tableView reloadData];
                            [strongSelf.tableView.mj_footer endRefreshing];
                        });
                    }];
                }else {
                    self.tableView.mj_footer = nil;
                }
            });
        }];
    }
}

- (void)loadMoreDataTest {
    [self.dataSource addObject:@"加载更多成功"];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isFirstLoaded) {
        //用来模拟未加载就没有数据，测试代码而已
        return 0;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback?:self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listViewLoadDataIfNeeded {
    if (!self.isFirstLoaded) {
        self.isFirstLoaded = YES;
        if (self.isNeedHeader) {
            [self.tableView.mj_header beginRefreshing];
        }else {
            [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
                [self.tableView reloadData];

                if (self.dataSource.count >= 10) {
                    //模拟加载完数据之后添加footer
                    __strong typeof(self)weakSelf = self;
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.dataSource addObject:@"加载更多成功"];
                            [weakSelf.tableView reloadData];
                            [weakSelf.tableView.mj_footer endRefreshing];
                        });
                    }];
                }else {
                    self.tableView.mj_footer = nil;
                }
            });
        }
    }
}

@end
