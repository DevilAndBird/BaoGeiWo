//
//  DeliverySuccessViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "DeliverySuccessViewController.h"

@interface DeliverySuccessViewController ()

@property (nonatomic, assign) NSInteger type; //1: 申请  2: 交接

@end

@implementation DeliverySuccessViewController


- (instancetype)initWithType:(NSInteger)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.type == 1) {
        self.navigationBar.titleLabel.text = @"申请成功";
    } else {
        self.navigationBar.titleLabel.text = @"交接成功";
    }
    
    UIImageView *successImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_deliver_success"]];
    [self.view addSubview:successImage];
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.mas_offset(-100);
    }];
    
    UILabel *successLabel = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(16)];
    successLabel.text = self.navigationBar.titleLabel.text;
    [self.view addSubview:successLabel];
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(successImage.mas_bottom).with.offset(20);
    }];
    
    UIButton *backHomeButton = [[UIButton alloc] init];
    [backHomeButton setTitle:@"返回首页" forState:UIControlStateNormal];
    backHomeButton.backgroundColor = kMThemeColor;
    backHomeButton.titleLabel.font = BGWFont(14);
    [backHomeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backHomeButton];
    [backHomeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.mas_offset(60);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
    
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
