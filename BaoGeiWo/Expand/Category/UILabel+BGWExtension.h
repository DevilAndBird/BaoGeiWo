//
//  UILabel+BGWExtension.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (BGWExtension)

- (instancetype)initWithTextColor:(UIColor *)textColor font:(UIFont *)font;
- (instancetype)initWithTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

@end
