//
//  TestTableView.m
//  JXPageListView
//
//  Created by jiaxin on 2018/9/17.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TestTableView.h"

@implementation TestTableView

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];

    NSLog(@"contentInset:%f", contentInset.top);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
