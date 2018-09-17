//
//  ViewController.m
//  JXPageListView
//
//  Created by jiaxin on 2018/9/14.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"
#import "NormalViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            {
                NormalViewController *vc = [[NormalViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 1:
            {
                PageViewController *vc = [[PageViewController alloc] init];
                vc.isNeedHeader = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2:
            {
                PageViewController *vc = [[PageViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        default:
            break;
    }
}

@end
