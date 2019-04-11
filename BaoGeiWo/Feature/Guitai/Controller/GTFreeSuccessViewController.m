//
//  GTFreeSuccessViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/18.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTFreeSuccessViewController.h"
#import "GTFreeViewController.h"

@interface GTFreeSuccessViewController ()

@end

@implementation GTFreeSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.titleLabel.text = @"释放成功";
    
    UIImageView *successImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_deliver_success"]];
    [self.view addSubview:successImage];
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.mas_offset(-100);
    }];
    
    UILabel *successLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    successLabel.text = @"释放成功";
    [self.view addSubview:successLabel];
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(successImage.mas_bottom).with.offset(20);
    }];
    
    UIButton *backHomeButton = [[UIButton alloc] init];
    [backHomeButton setTitle:@"返回首页" forState:UIControlStateNormal];
    backHomeButton.backgroundColor = kMThemeColor;
    backHomeButton.titleLabel.font = BGWFont(14);
    [backHomeButton setCornerRadius:4.f boderWidth:0 borderColor:kMThemeColor];
    [backHomeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backHomeButton];
    [backHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0).with.offset(-80);
        make.centerY.mas_offset(60);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    
    UIButton *continueFreeButton = [[UIButton alloc] init];
    [continueFreeButton setTitle:@"继续释放" forState:UIControlStateNormal];
    continueFreeButton.backgroundColor = kMThemeColor;
    continueFreeButton.titleLabel.font = BGWFont(14);
    [continueFreeButton setCornerRadius:4.f boderWidth:0 borderColor:kMThemeColor];
    [continueFreeButton addTarget:self action:@selector(continueFree) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:continueFreeButton];
    [continueFreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0).with.offset(80);
        make.centerY.mas_offset(60);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    
}

- (void)continueFree {
    GTFreeViewController *vc = [[GTFreeViewController alloc] init];
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [vcs insertObject:vc atIndex:1];
    [self.navigationController setViewControllers:vcs];
    [self.navigationController popToViewController:vc animated:YES];
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
