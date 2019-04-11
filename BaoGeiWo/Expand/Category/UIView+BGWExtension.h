//
//  UIView+BGWExtension.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BGWExtension)

@property (nonatomic, assign) CGFloat bgw_x;
@property (nonatomic, assign) CGFloat bgw_y;
@property (nonatomic, assign) CGFloat bgw_w;
@property (nonatomic, assign) CGFloat bgw_h;
@property (nonatomic, assign) CGFloat bgw_centerX;
@property (nonatomic, assign) CGFloat bgw_centerY;
@property (nonatomic, assign) CGSize bgw_size;

- (void)setCornerRadius:(CGFloat)radius boderWidth:(CGFloat)width borderColor:(UIColor *)color;

@end
