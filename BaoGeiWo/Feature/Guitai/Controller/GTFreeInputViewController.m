//
//  GTFreeInputViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/6/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "GTFreeInputViewController.h"
#import "MQVerCodeInputView.h"

#import "GTFreeOrderDetailViewController.h"

@interface GTFreeInputViewController ()

@property (nonatomic, strong) MQVerCodeInputView *inputView;

@end

@implementation GTFreeInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"输入提取码";
    
    UILabel *label = [[UILabel alloc] initWithTextColor:kMGrayColor font:BGWFont(14)];
    label.text = @"输入你已知的提取码，来完成验证";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(30);
        make.centerX.equalTo(@0);
    }];
    
    
    MQVerCodeInputView *inputView = [[MQVerCodeInputView alloc] init];
    inputView.keyBoardType = UIKeyboardTypeNumberPad;
    inputView.maxLenght = 6;
    inputView.viewColorHL = kMThemeColor;
    [inputView mq_verCodeViewWithMaxLenght];
    [self.view addSubview:inputView];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(20);
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    self.inputView = inputView;
    
    UIButton *comfirm = [[UIButton alloc] init];
    comfirm.backgroundColor = kMThemeColor;
    [comfirm setTitle:@"确认" forState:UIControlStateNormal];
    [comfirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comfirm];
    [comfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).with.offset(30);
        make.centerX.equalTo(@0);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
    }];
    
}

- (void)confirmClick {
    if (self.inputView.currentText.length < self.inputView.maxLenght) {
        POPUPINFO(@"请输入正确的提取码");
        return;
    }
    
    GTFreeOrderDetailViewController *vc = [[GTFreeOrderDetailViewController alloc] initWithFetchNo:self.inputView.currentText];
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
