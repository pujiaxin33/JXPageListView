# JXPageListView
高仿闲鱼、转转、京东、中央天气预报等主流APP列表底部分页滚动视图

# 特性

- 上下左右滚动交互流畅；
- 支持MJRefresh等header加载；
- 支持HUD loading加载；
- 支持底部分类滚动列表状态保存；
- 支持底部分类滚动列表状态不保存；

# 效果预览

| 说明 | GIF|
|------|------|
| 上下左右交互 | ![](https://github.com/pujiaxin33/JXPageListView/blob/master/JXPageListView/Gif/scrollInteraction.gif)|
| MJRefresh刷新加载 | ![](https://github.com/pujiaxin33/JXPageListView/blob/master/JXPageListView/Gif/headerLoading.gif) |
| HUD loading加载 | ![](https://github.com/pujiaxin33/JXPageListView/blob/master/JXPageListView/Gif/hudLoading.gif)
| 保存底部列表滚动状态 | ![](https://github.com/pujiaxin33/JXPageListView/blob/master/JXPageListView/Gif/listScrollStateSave.gif) |
| 不保存底部列表滚动状态 | ![](https://github.com/pujiaxin33/JXPageListView/blob/master/JXPageListView/Gif/listScrollStateNoSave.gif) |
| **JXPagingView** <br/>如果只需要HeaderView <br/>请点击查看该库[JXPagingView](https://github.com/pujiaxin33/JXPagingView) <br/>请点击查看该库[JXPagingView](https://github.com/pujiaxin33/JXPagingView) <br/>请点击查看该库[JXPagingView](https://github.com/pujiaxin33/JXPagingView) | ![Zoom](https://github.com/pujiaxin33/JXPagingView/blob/master/JXPagingView/Gif/Zoom.gif) | 

# 使用

- 初始化`pageListView`

```Objective-C
self.pageListView = [[JXPageListView alloc] initWithDelegate:self];
```

- 配置分类视图`pinCategoryView`

```Objective-C
self.pageListView.pinCategoryView.titles = self.titles;
```

- 成为mainTableView的代理，像使用普通UITableView一样使用它；
```Objective-C
self.pageListView.mainTableView.dataSource = self;
self.pageListView.mainTableView.delegate = self;
```

- `UITableViewDataSource, UITableViewDelegate`代理方法实现

```Objective-C
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + “你的顶部内容section数量”;//底部的分类滚动视图需要作为最后一个section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        //Tips:最后一个section（即listContainerCell所在的section）需要返回1
        return 1;
    }
    //返回你的顶部内容 row number
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        //Tips:最后一个section（即listContainerCell所在的section）返回listContainerCell的高度
        return [self.pageListView listContainerCellHeight];
    }
     //返回你的顶部内容 cell height
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        //Tips:最后一个section（即listContainerCell所在的section）配置listContainerCell
        return [self.pageListView listContainerCellForRowAtIndexPath:indexPath];
    }
   //返回你的顶部内容 cell
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //Tips:需要传入mainTableView的scrollViewDidScroll事件
    [self.pageListView mainTableViewDidScroll:scrollView];
}
```

- `JXPageViewDelegate`代理方法实现
```Objective-C
//返回底部的列表视图
- (NSArray<UIView<JXPageListViewListDelegate> *> *)listViewsInPageListView:(JXPageListView *)pageListView {
    return self.listViewArray;
}
```

# JXPagingView推荐
如果你只想找一个顶部只有少量视图（类似TableHeaderView的概念），推荐你看我的这个库：[JXPagingView](https://github.com/pujiaxin33/JXPagingView)

# JXCategoryView推荐
如果你想要支持所有主流APP分类切换效果的框架，推荐你看我的这个库，目前已经1.4k stars：[JXCategoryView](https://github.com/pujiaxin33/JXCategoryView)

# 补充
有任何疑问欢迎通过以下方式联系我：
- 提issue；
- 邮箱：317437087@qq.com
- QQ：317437087
