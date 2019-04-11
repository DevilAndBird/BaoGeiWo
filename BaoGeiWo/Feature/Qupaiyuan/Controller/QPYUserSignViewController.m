//
//  QPYUserSignViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/29.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "QPYUserSignViewController.h"
#import "DrawView.h"
#import "OrderRequest.h"
#import "AliyunOSSService.h"

@interface QPYUserSignViewController ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong) DrawView *drawView;

@end

@implementation QPYUserSignViewController

- (instancetype)initWithUserName:(NSString *)name orderId:(NSString *)orderId {
    if (self) {
        self.name = name;
        self.orderId = orderId;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleLabel.text = @"客户签名";
    
//    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, DEVICE_SCREEN_WIDTH-24 , 44)];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:whiteView];
//    whiteView.layer.masksToBounds = YES;
//    whiteView.layer.cornerRadius = 4;
//
//    UILabel *label = [[UILabel alloc] initWithTextColor:kMBlackColor font:BGWFont(14)];
//    label.text = @"收件人姓名";
//    [whiteView addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@10);
//        make.centerY.equalTo(@0);
//    }];
//
//    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, DEVICE_SCREEN_WIDTH-120-12, 44)];
//    textField.text = _order.orderSenderReceiver.receivername;
//    textField.textColor = BLACKTEXTCOLOR;
//    [whiteView addSubview:_textField];
//    textField.font = [UIFont systemFontOfSize:14];
    
    DrawView *view = [[DrawView alloc] init];
    view.backgroundColor = kWhiteColor;
    view.lineWidth = 5.f;
    view.lineColor = kMBlackColor;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).with.offset(10);
        make.left.equalTo(@10);
        make.right.mas_offset(-10);
        make.height.equalTo(@200);
    }];
    self.drawView = view;
    
    UIButton *clearBtn = [UIButton new];
    [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.backgroundColor = [UIColor whiteColor];
    [clearBtn setTitleColor:kMThemeColor forState:UIControlStateNormal];
    clearBtn.layer.cornerRadius = 4;
    clearBtn.layer.masksToBounds = YES;
    clearBtn.layer.borderColor = kMThemeColor.CGColor;
    clearBtn.layer.borderWidth = 0.8;
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [self.view addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@24);
        make.top.equalTo(view.mas_bottom).with.offset(30);
        make.height.equalTo(@44);
    }];
    
    UIButton *confirmBtn = [UIButton new];
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = kMThemeColor;
    confirmBtn.layer.cornerRadius = 4;
    [confirmBtn setTitle:@"确认签字" forState:UIControlStateNormal];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(clearBtn.mas_right).with.offset(48);
        make.right.mas_offset(-24);
        make.width.height.bottom.equalTo(clearBtn);
    }];
}


#pragma mark - 清除
-(void)clear{
    [self.drawView clean];
    
}
#pragma mark - 确认签字
-(void)confirm{
    
    [SVProgressHUD show];
    [self.drawView save];
    [[AliyunOSSService shareInstance] uploadObjectWithImage:self.drawView.savedImage success:^(id responseObject) {
        [OrderRequest SaveUserSignWithOrderId:self.orderId userName:self.name userSign:responseObject success:^(id responseObject) {
            [SVProgressHUD dismiss];
            POPUPINFO(@"签名保存成功");
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(id error) {
            [SVProgressHUD dismiss];
        }];
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
    
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
