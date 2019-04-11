//
//  BGWNavigationBar.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGWNavigationBar : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong, readonly) UIButton *backButton;


@property (nonatomic, assign) NSInteger rightButtonWidth;


@end
