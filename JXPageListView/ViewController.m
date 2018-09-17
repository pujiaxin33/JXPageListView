//
//  ViewController.m
//  JXPageListView
//
//  Created by jiaxin on 2018/9/14.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PageViewController *vc = [[PageViewController alloc] init];
    if (indexPath.row == 0) {
        vc.isNeedHeader = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
