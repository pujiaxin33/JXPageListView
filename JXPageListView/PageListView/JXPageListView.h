//
//  JXPageView.h
//
//  Created by jiaxin on 2018/9/13.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPageListMainTableView.h"
#import "JXPageListContainerView.h"
#import "JXCategoryView.h"

@class JXPageListView;

@protocol JXPageListViewListDelegate <NSObject>


/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了顶部内容，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView;


/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback

 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback;

/**
 选中listView之后触发数据加载。会多次回调，所以listView内部要做个标志，第一次才触发数据加载。
 */
- (void)listViewLoadDataIfNeeded;

@end

@protocol JXPageListViewDelegate <NSObject>

/**
 返回listViews，数组的item需要是UIView的子类，且要遵循JXPageListViewListDelegate。
 数组item要求返回一个UIView而不是一个UIScrollView，因为列表的UIScrollView一般是被包装到一个view里面，里面会处理数据源和其他逻辑。

 @param pageListView pageListView description
 @return listViews
 */
- (NSArray <UIView <JXPageListViewListDelegate>*>*)listViewsInPageListView:(JXPageListView *)pageListView;

@optional

/**
 悬浮分类视图选中某个index的回调

 @param pinCategoryView 悬浮分类视图
 @param index index
 */
- (void)pinCategoryView:(JXCategoryBaseView *)pinCategoryView didSelectedItemAtIndex:(NSInteger)index;

@end


/**
 按照demo工程PageViewController里面的tips使用，把最后一个section留给listContainerCell。其余的，你就把mainTableView当做普通的tableView来处理就行。上面想添加多少cell都随你。
 */
@interface JXPageListView : UIView

@property (nonatomic, assign) BOOL isNeedSyncListViewContentOffsetY;    //是否需要同步列表视图的y值。默认：NO。设置为NO时

@property (nonatomic, assign) CGFloat pinCategoryViewHeight;

@property (nonatomic, strong, readonly) JXCategoryTitleView *pinCategoryView;

@property (nonatomic, strong, readonly) JXPageListMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<JXPageListViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (CGFloat)getListContainerCellHeight;

- (UITableViewCell *)configListContainerCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 mainTableView的代理方法`scrollViewDidScroll`回调时需要调用该方法

 @param scrollView mainTableView
 */
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView;

@end
