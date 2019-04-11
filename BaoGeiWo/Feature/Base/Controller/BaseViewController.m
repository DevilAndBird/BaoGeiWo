//
//  BaseViewController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/2.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc {
    NSLog(@"dealloc---- %@", NSStringFromClass([self class]));
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kMBgColor;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@(KNavBarHeight));
    }];
    [self.navigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:self.baseTableView];
 
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    //    if ([AppDelegate sharedAppDelegate].reachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
    //        POPUPINFO(@"当前无网络，请检查网络设置");
    ////        [self.view addSubview:self.notReachablePlaceholderView];
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void(^)(void))cancel confirm:(void(^)(void))confirm {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel();
        }
    }];
    UIAlertAction *confirmA = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirm) {
            confirm();
        }
    }];
    [alert addAction:cancelA];
    [alert addAction:confirmA];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}




- (void)setNavigationBarHidder:(BOOL)navigationBarHidder {
    self.navigationBar.hidden = navigationBarHidder;
}
- (void)setNavBackButtonHidder:(BOOL)navBackButtonHidder {
    self.navigationBar.backButton.hidden = YES;
}

- (BGWNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[BGWNavigationBar alloc] initWithFrame:CGRectZero];
        _navigationBar.backgroundColor = kMThemeColor;
        
    }
    
    return _navigationBar;
}

- (UIView *)noContentView {
    if (!_noContentView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-KNavBarHeight)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_empty_placrholder"]];
        imageView.frame = CGRectMake(DEVICE_WIDTH/2-50, (DEVICE_HEIGHT-64)/2-50-50, 100, 100);
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bgw_y+imageView.bgw_h+30, DEVICE_WIDTH, 15)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"啊喔，什么也木有～";
        label.textColor = kMPromptColor;
        label.font = BGWFont(14);
        [view addSubview:label];
        
        _noContentView = view;
    }
    return _noContentView;
}




//Interface的方向是否会跟随设备方向自动旋转，如果返回NO,后两个方法不会再调用
- (BOOL)shouldAutorotate {
    return NO;
}
//返回直接支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
//返回最优先显示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
