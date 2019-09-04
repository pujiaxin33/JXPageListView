//
//  PageViewController.m
//  JXpageListViewExample-OC
//
//  Created by jiaxin on 2018/9/13.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "PageViewController.h"
#import "JXPageListView.h"
#import "TestListBaseView.h"
#import "MBProgressHUD.h"

static const CGFloat JXPageheightForHeaderInSection = 50;

@interface PageViewController () <JXPageListViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) JXPageListView *pageListView;
@property (nonatomic, strong) NSArray <TestListBaseView *> *listViewArray;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"路飞档案";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = false;
    _titles = @[@"能力", @"爱好", @"队友"];

    TestListBaseView *powerListView = [[TestListBaseView alloc] init];
    powerListView.isNeedHeader = self.isNeedHeader;
    powerListView.dataSource = @[@"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮", @"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮"].mutableCopy;

    TestListBaseView *hobbyListView = [[TestListBaseView alloc] init];
    hobbyListView.isNeedHeader = self.isNeedHeader;
    hobbyListView.dataSource = @[@"吃烤肉", @"吃鸡腿肉", @"吃牛肉", @"各种肉"].mutableCopy;

    TestListBaseView *partnerListView = [[TestListBaseView alloc] init];
    partnerListView.isNeedHeader = self.isNeedHeader;
    partnerListView.dataSource = @[@"【剑士】罗罗诺亚·索隆", @"【航海士】娜美", @"【狙击手】乌索普", @"【厨师】香吉士", @"【船医】托尼托尼·乔巴", @"【船匠】 弗兰奇", @"【音乐家】布鲁克", @"【考古学家】妮可·罗宾"].mutableCopy;

    _listViewArray = @[powerListView, hobbyListView, partnerListView];

    self.pageListView = [[JXPageListView alloc] initWithDelegate:self];
    self.pageListView.listViewScrollStateSaveEnabled = self.listViewScrollStateSaveEnabled;
    self.pageListView.pinCategoryViewVerticalOffset = self.pinCategoryViewVerticalOffset;
    //Tips:pinCategoryViewHeight要赋值
    self.pageListView.pinCategoryViewHeight = JXPageheightForHeaderInSection;
    //Tips:操作pinCategoryView进行配置
    self.pageListView.pinCategoryView.titles = self.titles;

    //添加分割线，这个完全自己配置
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, JXPageheightForHeaderInSection - 1, self.view.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.pageListView.pinCategoryView addSubview:lineView];

    //Tips:成为mainTableView dataSource和delegate的代理，像普通UITableView一样使用它
    self.pageListView.mainTableView.dataSource = self;
    self.pageListView.mainTableView.delegate = self;
    self.pageListView.mainTableView.scrollsToTop = NO;
    [self.pageListView.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.pageListView];

    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);

    if (self.isNeedScrollToBottom) {
      UIBarButtonItem *scrollToBottomItem =  [[UIBarButtonItem alloc] initWithTitle:@"滚动到底部" style:UIBarButtonItemStylePlain target:self action:@selector(naviRightItemDidClick)];
      UIBarButtonItem *selectBottomIndexItem =  [[UIBarButtonItem alloc] initWithTitle:@"主动切换底部" style:UIBarButtonItemStylePlain target:self action:@selector(selectBottomItemDidClick)];
        self.navigationItem.rightBarButtonItems = @[scrollToBottomItem, selectBottomIndexItem];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.pageListView.frame = self.view.bounds;
}

- (void)naviRightItemDidClick {
    [self.pageListView.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)selectBottomItemDidClick {
    [self.pageListView selectPageListAtIndex:arc4random_uniform(_listViewArray.count)];
}

#pragma mark - JXPageViewDelegate
//Tips:实现代理方法
- (NSArray<UIView<JXPageListViewListDelegate> *> *)listViewsInPageListView:(JXPageListView *)pageListView {
    return self.listViewArray;
}

- (void)pinCategoryView:(JXCategoryBaseView *)pinCategoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + 1;//底部的分类滚动视图需要作为最后一个section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        //Tips:最后一个section（即listContainerCell所在的section）需要返回1
        return 1;
    }
    if (section == 0) {
        return 10;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        //Tips:最后一个section（即listContainerCell所在的section）返回listContainerCell的高度
        return [self.pageListView listContainerCellHeight];
    }
    if (indexPath.section == 0) {
        return 70;
    }

    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        //Tips:最后一个section（即listContainerCell所在的section）配置listContainerCell
        return [self.pageListView listContainerCellForRowAtIndexPath:indexPath];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Your custom cell:%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    if (indexPath.section == 0) {
        cell.textLabel.textColor = [UIColor redColor];
    }else {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Tips:需要传入mainTableView的scrollViewDidScroll事件
    [self.pageListView mainTableViewDidScroll:scrollView];
}


@end
