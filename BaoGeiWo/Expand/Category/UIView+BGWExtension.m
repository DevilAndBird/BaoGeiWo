//
//  UIView+BGWExtension.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "UIView+BGWExtension.h"

@implementation UIView (BGWExtension)

- (void)setBgw_x:(CGFloat)bgw_x
{
    CGRect frame = self.frame;
    frame.origin.x = bgw_x;
    self.frame = frame;
}

- (CGFloat)bgw_x
{
    return self.frame.origin.x;
}

- (void)setBgw_y:(CGFloat)bgw_y
{
    CGRect frame = self.frame;
    frame.origin.y = bgw_y;
    self.frame = frame;
}

- (CGFloat)bgw_y
{
    return self.frame.origin.y;
}

- (void)setBgw_centerX:(CGFloat)bgw_centerX
{
    CGPoint center = self.center;
    center.x = bgw_centerX;
    self.center = center;
}

- (CGFloat)bgw_centerX
{
    return self.center.x;
}

- (void)setBgw_centerY:(CGFloat)bgw_centerY
{
    CGPoint center = self.center;
    center.y = bgw_centerY;
    self.center = center;
}

- (CGFloat)bgw_centerY
{
    return self.center.y;
}

- (void)setBgw_w:(CGFloat)bgw_w
{
    CGRect frame = self.frame;
    frame.size.width = bgw_w;
    self.frame = frame;
}

- (CGFloat)bgw_w
{
    return self.frame.size.width;
}

- (void)setBgw_h:(CGFloat)bgw_h
{
    CGRect frame = self.frame;
    frame.size.height = bgw_h;
    self.frame = frame;
}

- (CGFloat)bgw_h
{
    return self.frame.size.height;
}

- (void)setBgw_size:(CGSize)bgw_size
{
    CGRect frame = self.frame;
    frame.size = bgw_size;
    self.frame = frame;
}

- (CGSize)bgw_size
{
    return self.frame.size;
}


- (void)setCornerRadius:(CGFloat)radius boderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.clipsToBounds = YES;
}

@end
