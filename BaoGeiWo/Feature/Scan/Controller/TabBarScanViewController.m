//
//  TabBarScanViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/29.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "TabBarScanViewController.h"

#import "CheckOrderDetailViewController.h"

@interface TabBarScanViewController ()

@end

@implementation TabBarScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
- (void)scanResult:(NSString *)result {
    CheckOrderDetailViewController *vc = [[CheckOrderDetailViewController alloc] initWithBaggageId:result taskType:BGWOrderTaskTypeFinished roleType:BGWRoleActionTypeOther];
    vc.backBlock = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
  
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
