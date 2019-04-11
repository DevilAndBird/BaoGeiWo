//
//  BGWNavigationBar.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BGWNavigationBar.h"

@implementation BGWNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat cy = KNavBarHeight/2+KStatusBarHeight/2;//centerY
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, DEVICE_WIDTH-140, 40)];
        title.bgw_centerY = cy;
        title.textColor = RGB(255, 255, 255);
        title.textAlignment = NSTextAlignmentCenter;
        title.font = BGWFont(18);
        title.text = @"没设置标题";
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.mas_offset((KStatusBarHeight/2));
            make.left.equalTo(@70);
        }];
        self.titleLabel = title;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(5, 0, 44, 44);
        [leftButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        //        [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        leftButton.bgw_centerY = cy;
        self.leftButton = leftButton;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = BGWFont(14);
        rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        rightButton.bgw_centerY = cy;
        [self addSubview:rightButton];
        self.rightButton = rightButton;
        
    }
    return self;
}

- (void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
    
    titleView.bgw_centerX = DEVICE_WIDTH/2;
    titleView.bgw_centerY = KNavBarHeight/2+KStatusBarHeight/2;
    
    
    NSLog(@"%@", NSStringFromCGRect(titleView.frame));
    [self addSubview:titleView];
}

- (void)setRightButtonWidth:(NSInteger)rightButtonWidth {
    _rightButtonWidth = rightButtonWidth;
    
    self.rightButton.frame = CGRectMake(DEVICE_WIDTH-15-rightButtonWidth, 0, rightButtonWidth, 40);
    self.rightButton.bgw_centerY = KNavBarHeight/2+KStatusBarHeight/2;
}

- (UIButton *)backButton {
    return self.leftButton;
}

@end
