//
//  GTFreeViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTFreeViewController.h"
#import "GTFreeOrderDetailViewController.h"
#import "GTFreeInputViewController.h"

@interface GTFreeViewController ()

@end

@implementation GTFreeViewController

- (instancetype)init {
    return [super initWithScanType:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *inputButton = [[UIButton alloc] init];
    inputButton.backgroundColor = kMThemeColor;
    [inputButton setTitle:@"手动输入提取码" forState:UIControlStateNormal];
    inputButton.titleLabel.font = BGWFont(16);
    [inputButton setCornerRadius:4.f boderWidth:0.f borderColor:nil];
    [inputButton addTarget:self action:@selector(inputClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputButton];
    [inputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanView.mas_bottom).with.offset(60);
        make.centerX.equalTo(@0);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
    }];
}

- (void)inputClick {
    GTFreeInputViewController *vc = [[GTFreeInputViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)scanResult:(NSString *)result {
    
    //roleType 释放行李
    GTFreeOrderDetailViewController *vc = [[GTFreeOrderDetailViewController alloc] initWithOrderNo:result];
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
