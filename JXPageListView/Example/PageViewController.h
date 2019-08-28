//
//  PageViewController.h
//
//  Created by jiaxin on 2018/9/13.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController
@property (nonatomic, assign) BOOL isNeedHeader;
@property (nonatomic, assign) BOOL listViewScrollStateSaveEnabled;
@property (nonatomic, assign) CGFloat pinCategoryViewVerticalOffset;
@property (nonatomic, assign) BOOL isNeedScrollToBottom;
@end
