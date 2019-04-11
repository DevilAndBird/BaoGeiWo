//
//  GTTakeViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTTakeViewController.h"

#import "OrderTaskDetailViewController.h"

@interface GTTakeViewController ()

@end

@implementation GTTakeViewController

- (instancetype)init {
    return [super initWithScanType:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)scanResult:(NSString *)result {
    
    //roleType 为了和取派员收取行李一致, 没有实际意义
    OrderTaskDetailViewController *vc = [[OrderTaskDetailViewController alloc] initWithOrderNo:result taskType:BGWOrderTaskTypeOther roleType:BGWRoleActionTypeHotelTask];
    [self.navigationController pushViewController:vc animated:YES];
    //移除扫描页
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        UIViewController *scanVc = vcs[vcs.count - 2];
        [vcs removeObject:scanVc];
        [self.navigationController setViewControllers:vcs];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
