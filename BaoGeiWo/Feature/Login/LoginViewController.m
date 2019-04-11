//
//  LoginViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseTabBarController.h"
#import "UserRequest.h"
#import "OrderRequest.h"
#import "OrderRequest-swift.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *account;
@property (nonatomic, strong) UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.hidden = YES;
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
    [self.view addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
    [self.view addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.mas_offset(-200);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = kWhiteColor;
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.centerX.equalTo(@0);
        make.height.equalTo(@.5);
        make.centerY.mas_offset(-50);
    }];
    
    UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    [self.view addSubview:userImage];
    [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line1).with.offset(10);
    }];
    [userImage setContentHuggingPriority:UILayoutPriorityDefaultLow+1 forAxis:UILayoutConstraintAxisHorizontal];
    
    UITextField *userTextField = [[UITextField alloc] init];
    userTextField.placeholder = @"请输入手机号";
    userTextField.keyboardType = UIKeyboardTypePhonePad;
    userTextField.textColor = kWhiteColor;
    [userTextField setValue:RGBA(255, 255, 255, 0.3) forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:userTextField];
    [userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userImage.mas_right).with.offset(20);
        make.right.equalTo(line1).with.offset(-20);
        make.bottom.equalTo(line1).with.offset(-5);
        make.height.equalTo(@30);
    }];
    [userImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userTextField);
    }];
    self.account = userTextField;
    
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = kWhiteColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line1);
        make.centerX.equalTo(line1);
        make.height.equalTo(line1);
        make.centerY.mas_offset(10);
    }];
    
    UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
    [self.view addSubview:passwordImage];
    [passwordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line2).with.offset(10);
    }];
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.placeholder = @"请输入密码";
    passwordTextField.textColor = kWhiteColor;
    [passwordTextField setValue:RGBA(255, 255, 255, 0.3) forKeyPath:@"_placeholderLabel.textColor"];
    passwordTextField.secureTextEntry = YES;
    [self.view addSubview:passwordTextField];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(userTextField);
        make.bottom.equalTo(line2).with.offset(-5);
    }];
    [passwordImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordTextField);
    }];
    self.password = passwordTextField;
    
    UIButton *login = [[UIButton alloc] init];
    login.backgroundColor = kWhiteColor;
    [login setTitleColor:kMThemeColor forState:UIControlStateNormal];
    [login setTitle:@"登 录" forState:UIControlStateNormal];
    [login setCornerRadius:4.f boderWidth:0 borderColor:nil];
    [login addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).with.offset(50);
        make.centerX.equalTo(@0);
        make.left.equalTo(@80);
        make.height.equalTo(@35);
    }];
}

- (void)userLogin {
    
    if (!self.account.text || [self.account.text isEqualToString:@""]) {
        POPUPINFO(@"请输入账号");
        return;
    }
    
    NSString *account = self.account.text;
    
#if BGW_ENVIRONMENT
    NSString *password;
    if (self.password.text && ![self.password.text isEqualToString:@""]) {
        password = self.password.text;
    } else {
        POPUPINFO(@"请输入密码");
        return;
    }
#else
    NSString *password = @"123456";
    if (self.password.text && ![self.password.text isEqualToString:@""]) {
        password = self.password.text;
    }
#endif
    
    [self.view endEditing:YES];
    [SVProgressHUD show];
    [UserRequest userLoginWithAccount:account password:password success:^(id responseObject) {
        [SVProgressHUD dismiss];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBGWLoginSuccessNotification object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kBGWNotificationSettingChangeNotification object:nil];

        [self loadMainVC];
        
    } failure:^(id error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)loadMainVC {
    
    if (self.dismissBlock) {
        self.dismissBlock();
        NSString *provinceId = [BGWUser currentUser].userRole.provinceId;
        NSString *cityId = [BGWUser currentUser].userRole.cityId;
        [OrderRequest_swift getCounterByProvinceId:provinceId cityId:cityId success:nil failure:nil];
        [OrderRequest_swift getEnterpriseCounterByProvinceId:provinceId cityId:cityId success:nil failure:nil];
        [OrderRequest getPricingRuleByCityId:cityId success:nil failure:nil];
        
    } else {
        
        BaseTabBarController *vc = [[BaseTabBarController alloc] init];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        typedef void (^Animation)(void);
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        Animation animation = ^{
            BOOL oldState = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:NO];
            [[[UIApplication sharedApplication] delegate] window].rootViewController = vc;
            [UIView setAnimationsEnabled:oldState];
        };
        
        [UIView transitionWithView:window
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:animation
                        completion:^(BOOL finished) {
                            [AppDelegate sharedAppDelegate].tabBarController = vc;
                        }];
    }
    
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
