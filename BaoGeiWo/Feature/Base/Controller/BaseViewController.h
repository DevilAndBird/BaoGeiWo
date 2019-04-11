//
//  BaseViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/2.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BGWNavigationBar.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) BGWNavigationBar *navigationBar;
@property (nonatomic, assign) BOOL navigationBarHidder;
@property (nonatomic, assign) BOOL navBackButtonHidder;

@property (nonatomic, strong) UIView *noContentView;

- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancel:(void(^)(void))cancel confirm:(void(^)(void))confirm;

@end
