//
//  JXPagingListContainerView.h
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXPageListMainTableView;
@class JXPageListContainerView;

@protocol JXPageListContainerViewDelegate <NSObject>

- (NSInteger)numberOfRowsInListContainerView:(JXPageListContainerView *)listContainerView;

- (UIView *)listContainerView:(JXPageListContainerView *)listContainerView listViewInRow:(NSInteger)row;

- (void)listContainerView:(JXPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row;

@end


@interface JXPageListContainerView : UIView

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<JXPageListContainerViewDelegate> delegate;
@property (nonatomic, weak) JXPageListMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<JXPageListContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

@end
